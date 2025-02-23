# frozen_string_literal: true

class Movie < ApplicationRecord
  belongs_to :user

  delegate :name, to: :user, prefix: true

  validates :title, presence: true
  validates :description, presence: true

  after_commit :refresh_aggregated_votes

  def vote_from(current_user_id)
    Vote.find_by(user_id: current_user_id, movie_id: id)
  end

  private

  def refresh_aggregated_votes
    RefreshAggregatedVotesJob.perform_later
  end
end
