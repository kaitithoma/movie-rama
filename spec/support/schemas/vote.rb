# frozen_string_literal: true

module Spec
  module Support
    module Schemas
      module Vote
        DEFINITION = {
          vote: {
            type: 'object',
            properties: {
              id: { type: 'string', example: '1' },
              type: { type: 'string', example: 'vote' },
              attributes: {
                vote_type: { type: 'string', enum: %w[ like dislike ] }
              },
              relationships: {
                user: { '$ref': '#/components/schemas/relationship_object' },
                movie: { '$ref': '#/components/schemas/relationship_object' }
              }
            }
          },
          vote_params: {
            type: 'object',
            properties: {
              movie_id: { type: 'integer', example: 1 },
              vote_type: { type: :string, enum: %w[ like dislike ] }
            }
          }
        }.freeze
      end
    end
  end
end
