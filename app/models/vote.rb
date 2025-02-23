# frozen_string_literal: true

class Vote < ApplicationRecord
  enum :vote_type, { like: "like", hate: "hate" }

  belongs_to :user
  belongs_to :movie

  validates :user_id, uniqueness: { scope: :movie_id }
  validates :vote_type, presence: true, inclusion: { in: Vote.vote_types.keys }
  validate :user_cannot_vote_their_own_movie

  after_commit :refresh_aggregated_votes

  private

  def user_cannot_vote_their_own_movie
    return unless Movie.find_by(id: movie_id)&.user_id == user_id

    errors.add(:user_id, "cannot vote their own movie")
  end

  def refresh_aggregated_votes
    RefreshAggregatedVotesJob.perform_later
  end
end
