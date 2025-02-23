# frozen_string_literal: true

class VotesController < BaseController
  def create
    @vote = current_user.votes.new(vote_params)
    return @vote.errors unless @vote.save

    render json: { message: "Vote successfully created" }, status: :created
  end

  def destroy
    @vote = current_user.votes.find_by(id: params[:id])
    return @vote.errors unless @vote.destroy

    render json: { message: "Vote successfully deleted" }, status: :ok
  end

  def update
    @vote = current_user.votes.find_by(id: params[:id])
    return @vote.errors unless @vote.update(vote_params)

    render json: { message: "Vote successfully updated" }, status: :ok
  end

  private

  def vote_params
    params.require(:vote).permit(:movie_id, :vote_type)
  end
end
