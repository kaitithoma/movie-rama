# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }

  it { is_expected.to delegate_method(:name).to(:user).with_prefix }

  context "when a movie is created" do
    let(:movie) { build(:movie) }

    it "enqueues a job to refresh the aggregated votes" do
      expect { movie.save }.to have_enqueued_job(RefreshAggregatedVotesJob)
    end
  end

  describe "#vote_from" do
    let(:user) { create(:user) }
    let(:movie) { create(:movie) }

    context "when the user has voted for the movie" do
      let!(:vote) { create(:vote, user: user, movie: movie) }

      it "returns the vote" do
        expect(movie.vote_from(user.id)).to eq(vote)
      end
    end

    context "when the user has not voted for the movie" do
      it "returns nil" do
        expect(movie.vote_from(user.id)).to be_nil
      end
    end
  end
end
