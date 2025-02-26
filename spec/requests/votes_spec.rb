# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'votes', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { "#{JsonWebToken.encode(user_id: user.id)}" }

  path '/votes' do
    post('create vote') do
      tags 'Votes'
      consumes 'application/json'
      security [ basic_auth: [] ]
      parameter name: :vote, in: :body, schema: { '$ref' => '#/components/schemas/vote_params' }

      response(201, 'vote created') do
        schema type: :object,
                properties: {
                  message: { type: :string },
                  data: { '$ref' => '#/components/schemas/vote' }
                }

        let(:movie) { create(:movie) }
        let(:vote) { { movie_id: movie.id, vote_type: :like } }
        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/errors'

        let(:vote) { { movie_id: 1, vote_type: :like } }
        let(:Authorization) { nil }
        run_test!
      end

      response 422, 'invalid params' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:id) { create(:vote, user:).id }
        let(:vote) { { movie_id: 1, vote_type: 'like' } }
        run_test!
      end

      response 422, 'invalid vote type', document: false do
        let(:id) { create(:vote, user:).id }
        let(:vote) { { movie_id: 1, vote_type: 'hatelike' } }
        run_test!
      end
    end
  end

  path '/votes/{id}', focus: true do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    patch('update vote') do
      tags 'Votes'
      consumes 'application/json'
      security [ basic_auth: [] ]
      parameter name: :vote, in: :body, schema: { '$ref' => '#/components/schemas/vote_params' }

      response(200, 'successful') do
        schema type: :object,
                properties: {
                  message: { type: :string },
                  data: { '$ref' => '#/components/schemas/vote' }
                }

        let(:id) { create(:vote, user:).id }
        let(:vote) { { vote_type: :hate } }
        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/errors'

        let(:id) { create(:vote, user:).id }
        let(:vote) { { movie_id: 1, vote_type: :like } }
        let(:Authorization) { nil }
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/errors'

        let(:id) { '123' }
        let(:vote) { { movie_id: 1, vote_type: :like } }
        run_test!
      end

      response 422, 'invalid params' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:id) { create(:vote, user:).id }
        let(:vote) { { movie_id: 1, vote_type: 'like' } }
        run_test!
      end

      response 422, 'invalid vote type', document: false do
        let(:id) { create(:vote, user:).id }
        let(:vote) { { movie_id: 1, vote_type: 'hatelike' } }
        run_test!
      end
    end

    delete('delete vote') do
      tags 'Votes'
      security [ basic_auth: [] ]
      consumes 'application/json'

      response(204, 'successful') do
        let(:id) { create(:vote, user:).id }
        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/errors'

        let(:id) { create(:vote, user:).id }
        let(:Authorization) { nil }
        run_test!
      end

      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/errors'

        let(:id) { '123' }
        run_test!
      end

      response 422, 'invalid params' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:id) { create(:vote, user:).id }
        let(:vote) { { movie_id: 1, vote_type: 'like' } }

        before do
          allow_any_instance_of(Vote).to receive(:destroy).and_return(false)
        end

        run_test!
      end
    end
  end
end
