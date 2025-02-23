# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    firstname { 'Bob' }
    lastname { 'Smith' }
    sequence(:email) { |n| "bsmith#{n}@test.com" }
    password { 'password' }
  end
end
