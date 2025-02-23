# frozen_string_literal: true

class BaseController < ApplicationController
  before_action :init_current_user
  before_action :authorize_request
  attr_reader :current_user

  private

  def init_current_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
  end

  def authorize_request
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
