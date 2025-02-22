# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create users
User.where(email: 'doej@sth.com').first_or_create(
  firstname: 'John',
  lastname: 'Doe',
  password: '12345'
)
User.where(email: 'aikelthoma@gmail.com').first_or_create(
  firstname: 'Kaiti',
  lastname: 'Thoma',
  password: '12345'
)

# Create movies
20.times do |i|
  Movie.where(title: Faker::Movie.title).first_or_create(
    description: Faker::Movie.quote,
    user: Random.rand(1..2).even? ? User.first : User.last
  )
end

# Create likes
50.times do |i|
  Like.find_or_create_by(
    user: Random.rand(1..2).even? ? User.first : User.last,
    movie: Movie.all[Random.rand(1..20)]
  )
end

# Create hates
50.times do |i|
  Hate.find_or_create_by(
    user: Random.rand(1..2).even? ? User.first : User.last,
    movie: Movie.all[Random.rand(1..20)]
  )
end
