# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'authentication', type: :request do
  let(:user) { create(:user) }

  path '/signup' do
    post('signup authentication') do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: { '$ref' => '#/components/schemas/user_params' }

      response '201', 'user created' do
        schema type: :object,
              properties: {
                token: { type: :string },
                user: { '$ref' => '#/components/schemas/user' }
              }

        let(:user) { { email: 'la@la.gr', password: '12345', firstname: 'Hello', lastname: 'World' } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/errors'

        let(:user) { { email: '', password: '12345', firstname: 'Hello', lastname: 'World' } }
        run_test!
      end
    end
  end

  path '/login' do
    post('login authentication') do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '200', 'user logged in' do
        schema type: :object,
                properties: {
                  token: { type: :string },
                  user: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      email: { type: :string }
                    },
                    required: %w[id email]
                  }
                }

        let(:user) { { email: 'la@la.gr', password: '12345' } }
        before { create(:user, email: 'la@la.gr', password: '12345', firstname: 'Hello', lastname: 'World') }

        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/errors'

        let(:user) { { email: 'wrong_email', password: 'wrong_password' } }
        run_test!
      end
    end
  end
end
