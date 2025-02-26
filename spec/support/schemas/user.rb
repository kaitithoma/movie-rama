# frozen_string_literal: true

module Spec
  module Support
    module Schemas
      module User
        DEFINITION = {
          user: {
            type: 'object',
            properties: {
              id: { type: 'integer', example: 1 },
              email: { type: 'string', example: 'user@gmail.com' }
            }
          },
          user_params: {
            type: 'object',
            properties: {
              email: { type: 'string', example: 'user@gmail.com' },
              password: { type: 'string', example: '123456' },
              firstname: { type: 'string', example: 'John' },
              lastname: { type: 'string', example: 'Doe' }
            },
            required: %w[email password firstname lastname]
          }
        }.freeze
      end
    end
  end
end
