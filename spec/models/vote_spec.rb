# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { build(:vote, user:, movie:) }

  # let definition is triggered before the subject is created to avoid enqueueing the relevant job twice
  let!(:movie) { create(:movie, user: create(:user)) }
  let(:user) { create(:user) }

  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:movie_id) }
  it { is_expected.to validate_presence_of(:vote_type) }
  it { is_expected.to allow_values("like", "hate").for(:vote_type) }

  context "when the movie belongs to the user" do
    let(:movie) { create(:movie, user:) }

    it "is invalid" do
      expect(subject).to be_invalid
    end

    it "adds an error message" do
      subject.valid?
      expect(subject.errors[:user_id]).to include("cannot vote their own movie")
    end
  end

  context "when the user has already voted" do
    subject { build(described_class.model_name.param_key.to_sym, user: user, movie: other_movie) }

    let(:other_movie) { create(:movie) }

    before { create(:vote, user: user, movie: other_movie) }

    it "is invalid" do
      expect(subject).to be_invalid
    end

    it "adds an error message" do
      subject.valid?
      expect(subject.errors[:user_id]).to include("has already been taken")
    end
  end

  context "when the vote is valid" do
    it "enqueues a job to refresh the aggregated votes" do
      expect { subject.save }.to have_enqueued_job(RefreshAggregatedVotesJob)
    end
  end
end
