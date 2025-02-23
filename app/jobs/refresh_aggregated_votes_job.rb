# frozen_string_literal: true

class RefreshAggregatedVotesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    AggregatedVote.refresh
  end
end
