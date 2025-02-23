# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshAggregatedVotesJob, type: :job do
  describe "#perform" do
    before do
      allow(AggregatedVote).to receive(:refresh)
      described_class.perform_now
    end

    it "calls AggregatedVote.refresh" do
      expect(AggregatedVote).to have_received(:refresh)
    end
  end
end
