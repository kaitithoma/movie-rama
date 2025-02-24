# frozen_string_literal: true

class RefreshAggregatedVotesJob < ApplicationJob
  limits_concurrency to: 1, key: :default

  def perform(args = {})
    AggregatedVote.transaction do
      AggregatedVote.refresh
    end
  end
end
