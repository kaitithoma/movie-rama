# frozen_string_literal: true

class RefreshAggregatedVotesJob < ApplicationJob
  CACHE_KEY = "refresh_aggregated_votes_job".freeze
  CACHE_EXPIRATION = 1.hour

  class << self
    private

    def cache_args(table_name)
      table_name.to_s
    end
  end

  def perform(args = {})
    return if self.class.job_in_progress?(table.name)

    self.class.add_to_running_jobs(table.name)
    table.send(:transaction) { table.send(:refresh) }
  ensure
    self.class.remove_from_running_jobs(table.name)
  end

  private

  def table
    AggregatedVote
  end
end
