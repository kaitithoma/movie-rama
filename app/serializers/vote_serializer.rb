# frozen_string_literal: true

class VoteSerializer < ApplicationSerializer
  attributes :vote_type

  belongs_to :user
  belongs_to :movie
end
