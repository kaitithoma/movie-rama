# frozen_string_literal: true

module Reporting
  module Movies
    class Overview
      def self.call(...)
        new(...).call
      end

      def initialize(args = {})
        @limit = args[:limit] || 10
        @page = args[:page] || 1
        @offset = (page.to_i - 1) * limit.to_i
        @sort_by = args[:sort_by]
        @sort_order = args[:sort_order]
        @user_id = args[:user_id]
        @current_user_id = args[:current_user_id]
      end

      def call
        Rails.cache.fetch("reporting/movies/overview/#{Digest::MD5.hexdigest(
          [ limit, page, sort_by, sort_order, user_id, current_user_id ].join
        )}", expires_in: 1.seconds) do
          data.merge(pagination).merge(total_records)
        end
      end

      private

      attr_reader :limit, :page, :offset, :sort_by, :sort_order, :user_id, :current_user_id

      def base_query
        AggregatedVote.select(:movie_id, :user_id, :likes_count, :hates_count)
                      .select("count(*) OVER() AS total_count")
                      .includes(:user)
                      .limit(limit)
                      .offset(offset)
      end

      def filter_user(query)
        return query unless user_id

        query.where(user_id:)
      end

      def order(query)
        return query unless sort_by

        query.order("#{sort_by} #{sort_order || 'DESC'}")
      end

      def results
        @results ||= filter_user order base_query
      end

      def created_days_ago(created_at)
        (Time.zone.now.to_date - created_at.to_date).to_i
      end

      def user_hash(user)
        { id: user.id, name: "#{user.firstname} #{user.lastname}" }
      end

      def preloaded_movies
        @preloaded_movies ||= Movie.where(id: results.map(&:movie_id))
                                   .includes(:user)
                                   .each_with_object({}) do |movie, hash|
                                     current_user_vote = movie.vote_from(current_user_id)

                                     hash[movie.id] = {
                                       id: movie.id,
                                       title: movie.title,
                                       description: movie.description,
                                       created_days_ago: created_days_ago(movie.created_at),
                                       user: user_hash(movie.user),
                                       vote_id: current_user_vote&.id,
                                       liked: current_user_vote&.like? || false,
                                       hated: current_user_vote&.hate? || false
                                     }
                                   end
      end

      def data
        {
          data: results.map do |result|
            preloaded_movies[result.movie_id].merge(
              likes_count: result.likes_count,
              hates_count: result.hates_count
            )
          end
        }
      end

      def total_records_number
        results&.first&.total_count || 0
      end

      def pagination
        { page:, per_page: [ limit.to_i, total_records_number || 0 ].min }
      end

      def total_records
        { total_records: total_records_number }
      end
    end
  end
end
