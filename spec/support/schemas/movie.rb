# frozen_string_literal: true

module Spec
  module Support
    module Schemas
      module Movie
        DEFINITION = {
          movie: {
            type: 'object',
            properties: {
              id: { type: 'string', example: '1' },
              type: { type: 'string', example: 'movie' },
              attributes: {
                title: { type: 'string', example: 'The Matrix' },
                description: { type: 'string', example: 'A movie about a matrix' },
                created_days_ago: { type: 'integer', example: 1 }
              },
              relationships: {
                user: { '$ref': '#/components/schemas/relationship_object' }
              }
            }
          },
          movie_params: {
            type: 'object',
            properties: {
              title: { type: 'string', example: 'The Matrix' },
              description: { type: 'string', example: 'A movie about a matrix' }
            },
            required: %w[ title description ]
          }
        }.freeze
      end
    end
  end
end
