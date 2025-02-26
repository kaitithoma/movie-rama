# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :firstname, :lastname, :email

  has_many :votes
  has_many :movies
end
