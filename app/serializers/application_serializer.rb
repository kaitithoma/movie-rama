# frozen_string_literal: true

# ApplicationSerializer class from which base serializer inherits
class ApplicationSerializer
  include ::JSONAPI::Serializer

  cache_options store: Rails.cache, namespace: "movie_rama_serializers", expires_in: 5.minutes
end
