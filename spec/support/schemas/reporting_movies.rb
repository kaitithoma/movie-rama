# frozen_string_literal: true

module Spec
  module Support
    module Schemas
      module ReportingMovies
        DEFINITION = {
          reporting_movies: {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'integer', example: 1 },
                    title: { type: 'string', example: 'The Matrix' },
                    description: { type: 'string', example: 'A movie about a matrix' },
                    created_days_ago: { type: 'integer', example: 1 },
                    user: {
                      type: 'object',
                      properties: {
                        id: { type: 'integer', example: 1 },
                        name: { type: 'string', example: 'Alice Smith' }
                      }
                    },
                    vote_id: { type: 'integer', example: 1, nullable: true },
                    liked: { type: 'boolean', default: false },
                    hated: { type: 'boolean', default: false },
                    likes_count: { type: 'integer', example: 1 },
                    hates_count: { type: 'integer', example: 1 }
                  }
                }
              },
              page: { type: 'integer', example: 1 },
              per_page: { type: 'integer', example: 10 },
              total_records: { type: 'integer', example: 1 }
            }
          }
        }.freeze
      end
    end
  end
end
