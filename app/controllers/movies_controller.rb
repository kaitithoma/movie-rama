# frozen_string_literal: true

class MoviesController < BaseController
  before_action :set_movie, only: [ :show, :edit ]
  skip_before_action :authorize_request, only: [ :new, :edit ]

  def new
    @movie = Movie.new
  end

  def show
    render json: @movie, status: :ok
  end

  def edit
  end

  def create
    @movie = current_user.movies.new(movie_params)
    return @movie.errors unless @movie.save

    render json: { message: "Movie successfully created", id: @movie.id }, status: :created
  end

  def update
    @movie = current_user.movies.find_by(id: params[:id])
    return @movie.errors unless @movie.update(movie_params)

    render json: { message: "Movie successfully updated" }, status: :ok
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :description)
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end
end
