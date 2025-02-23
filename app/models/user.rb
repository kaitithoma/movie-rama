# frozen_string_literal: true

require "bcrypt"

class User < ApplicationRecord
  has_secure_password

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :votes, dependent: :destroy
  has_many :movies, dependent: :restrict_with_error
end
