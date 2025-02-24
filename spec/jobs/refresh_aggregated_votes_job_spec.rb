# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshAggregatedVotesJob, type: :job do
  describe "#perform" do
    before do
      allow(AggregatedVote).to receive(:refresh)
      described_class.perform_now
    end

    after do
      Rails.cache.clear
    end

    it "calls AggregatedVote.refresh" do
      expect(AggregatedVote).to have_received(:refresh)
    end
  end

  context 'when the job is already running' do
    before do
      allow(AggregatedVote).to receive(:refresh)
      allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache.lookup_store(:memory_store))
      Rails.cache.write(described_class::CACHE_KEY, [ 'AggregatedVote' ])
      described_class.perform_now
    end

    it "does not call AggregatedVote.refresh" do
      expect(AggregatedVote).not_to have_received(:refresh)
    end
  end
end
