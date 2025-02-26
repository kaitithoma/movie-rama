# frozen_string_literal: true

module Spec
  module Support
    module Schemas
      module_function

      def get
        [ Errors, Movie, Vote, User, ReportingMovies, Meta ].inject({}) { |hash, klass| hash.merge(klass::DEFINITION) }
      end
    end
  end
end
