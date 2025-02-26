# frozen_string_literal: true

module Spec
  module Support
    module Schemas
      module Meta
        DEFINITION = {
          relationship_object: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :string, example: '1' },
                  type: { type: :string }
                },
                nullable: true
              }
            }
          }
        }.freeze
      end
    end
  end
end
