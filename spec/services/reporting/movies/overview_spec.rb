# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reporting::Movies::Overview, type: :service do
  let(:args) { {} }
  let(:service) { described_class.call(args) }
  let(:user1) { create(:user, firstname: 'Alice', lastname: 'Smith') }
  let(:user2) { create(:user, firstname: 'Bob', lastname: 'Smith') }
  let(:movie1) { create(:movie, title: 'The Matrix', created_at: 1.day.ago, user: user1) }
  let(:movie2) { create(:movie, title: 'The Matrix Reloaded', created_at: 2.days.ago, user: user2) }
  let(:movie3) { create(:movie, title: 'The Matrix Revolutions', created_at: 3.days.ago, user: user1) }
  let!(:vote1) { create(:vote, movie: movie1, user: user2, vote_type: :like) }
  let!(:vote2) { create(:vote, movie: movie2, user: user1, vote_type: :like) }
  let!(:vote3) { create(:vote, movie: movie3, user: user2, vote_type: :like) }

  before do
    create(:vote, movie: movie1, vote_type: :hate)
    create_list(:vote, 2, movie: movie3, vote_type: :hate)

    AggregatedVote.refresh
  end

  it 'returns the correct data' do
    expect(service[:data]).to contain_exactly(
      {
        id: movie1.id,
        title: 'The Matrix',
        description: movie1.description,
        created_days_ago: 1,
        user: { id: user1.id, name: 'Alice Smith' },
        vote_id: nil,
        liked: false,
        hated: false,
        likes_count: 1,
        hates_count: 1
      },
      {
        id: movie2.id,
        title: 'The Matrix Reloaded',
        description: movie2.description,
        created_days_ago: 2,
        user: { id: user2.id, name: 'Bob Smith' },
        vote_id: nil,
        liked: false,
        hated: false,
        likes_count: 1,
        hates_count: 0
      },
      {
        id: movie3.id,
        title: 'The Matrix Revolutions',
        description: movie3.description,
        created_days_ago: 3,
        user: { id: user1.id, name: 'Alice Smith' },
        vote_id: nil,
        liked: false,
        hated: false,
        likes_count: 1,
        hates_count: 2
      }
    )
  end

  it 'returns the correct pagination info' do
    expect(service[:page]).to eq(1)
    expect(service[:per_page]).to eq(3)
  end

  it 'returns the correct total records' do
    expect(service[:total_records]).to eq(3)
  end

  context 'when user_id (filter) is provided' do
    let(:args) { { user_id: user1.id } }

    it 'returns the movies created by this user' do
      expect(service[:data]).to contain_exactly(
        {
          id: movie1.id,
          title: 'The Matrix',
          description: movie1.description,
          created_days_ago: 1,
          user: { id: user1.id, name: 'Alice Smith' },
          vote_id: nil,
          liked: false,
          hated: false,
          likes_count: 1,
          hates_count: 1
        },
        {
          id: movie3.id,
          title: 'The Matrix Revolutions',
          description: movie3.description,
          created_days_ago: 3,
          user: { id: user1.id, name: 'Alice Smith' },
          vote_id: nil,
          liked: false,
          hated: false,
          likes_count: 1,
          hates_count: 2
        }
      )
    end
  end

  context 'when sort_by is provided without order' do
    let(:args) { { sort_by: 'hates_count' } }

    it 'sorts the movies by likes_count in descending order' do
      expect(service[:data].map { |i| i[:hates_count] }).to eq([ 2, 1, 0 ])
    end
  end

  context 'when current_user_id is provided' do
    let(:args) { { current_user_id: user1.id } }

    it 'returns the liked / hated fields and the user\'s vote ID' do
      expect(service[:data].detect { |result| result[:id] == movie2.id }).to eq(
        {
          id: movie2.id,
          title: 'The Matrix Reloaded',
          description: movie2.description,
          created_days_ago: 2,
          user: { id: user2.id, name: 'Bob Smith' },
          vote_id: vote2.id,
          liked: true,
          hated: false,
          likes_count: 1,
          hates_count: 0
        }
      )
    end
  end
end
