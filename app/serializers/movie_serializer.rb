# frozen_string_literal: true

class MovieSerializer < ApplicationSerializer
  attributes :title, :description, :created_days_ago

  belongs_to :user
end
