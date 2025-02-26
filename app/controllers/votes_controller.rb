# frozen_string_literal: true

class VotesController < BaseController
  before_action :set_vote, only: [ :destroy, :update ]

  def create
    @vote = current_user.votes.new(vote_params)
    return api_message object: @vote, status: :created if @vote.save

    api_error errors: @vote.errors, status: :unprocessable_entity
  rescue ArgumentError => e
    api_error errors: e.message, status: :unprocessable_entity
  end

  def destroy
    return api_error errors: [ "Vote not found" ], status: :not_found unless @vote
    return head :no_content if @vote.destroy

    api_error errors: @vote.errors, status: :unprocessable_entity
  end

  def update
    return api_error errors: [ "Vote not found" ], status: :not_found unless @vote
    return api_message object: @vote if @vote.update(vote_params)

    api_error errors: @vote.errors, status: :unprocessable_entity
  rescue ArgumentError => e
    api_error errors: e.message, status: :unprocessable_entity
  end

  private

  def set_vote
    @vote = current_user.votes.find_by(id: params[:id])
  end

  def vote_params
    params.require(:vote).permit(:movie_id, :vote_type)
  end
end
