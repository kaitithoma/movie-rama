# frozen_string_literal: true

module Spec
  module Support
    module Schemas
      module Errors
        DEFINITION = {
          errors: {
            type: 'object',
            properties: {
              errors: {
                type: :array,
                items: { type: 'string' }
              }
            }
          },
          errors_object: {
            type: 'object',
            properties: {
              errors: {
                type: :object,
                additionalProperties: {
                  type: 'array',
                  items: { type: 'string' }
                }
              }
            }
          }
        }.freeze
      end
    end
  end
end
