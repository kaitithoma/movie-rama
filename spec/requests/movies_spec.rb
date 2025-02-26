# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/movies', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { "#{JsonWebToken.encode(user_id: user.id)}" }

  path '/movies' do
    post 'Creates a movie' do
      parameter name: :movie, in: :body, schema: { '$ref' => '#/components/schemas/movie_params' }

      tags 'Movies'
      consumes 'application/json'
      security [ basic_auth: [] ]

      response '201', 'movie created' do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 data: { '$ref' => '#/components/schemas/movie' }
               }

        let(:movie) { { title: 'Inception', description: 'A movie about dreams' } }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/errors'

        let(:movie) { { title: 'Inception', description: 'A movie about dreams' } }
        let(:Authorization) { nil }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:movie) { { title: '' } }
        run_test!
      end
    end
  end
end
