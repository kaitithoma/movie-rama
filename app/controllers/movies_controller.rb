# frozen_string_literal: true

class MoviesController < BaseController
  before_action :set_movie, only: [ :show, :edit ]
  skip_before_action :authorize_request, only: [ :new, :edit ]

  def create
    @movie = current_user.movies.new(movie_params)
    return api_message object: @movie, status: :created if @movie.save

    api_error errors: @movie.errors, status: :unprocessable_entity
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :description)
  end
end
