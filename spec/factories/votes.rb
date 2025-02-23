# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    user
    movie
    vote_type { :like }
  end
end
