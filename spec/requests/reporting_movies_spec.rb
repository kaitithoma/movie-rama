require 'swagger_helper'

RSpec.describe 'reporting_movies', type: :request, focus: true do
  before(:all) do
    user = create(:user)
    voter = create(:user)
    5.times { create(:movie, user: user) }
    Movie.all.each do |movie|
      create(:vote, user: voter, movie: movie)
    end
    AggregatedVote.refresh
  end

  after(:all) { DatabaseCleaner.clean_with(:truncation) }

  path '/reporting_movies/overview' do
    get('overview reporting_movie') do
      tags 'Reporting Movies'
      consumes 'application/json'
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :sort_by, in: :query, type: :string, required: false
      parameter name: :sort_order, in: :query, type: :string, required: false
      parameter name: :user_id, in: :query, type: :integer, required: false

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/reporting_movies'
        run_test!
      end
    end
  end
end
