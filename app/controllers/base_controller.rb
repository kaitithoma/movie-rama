# frozen_string_literal: true

class BaseController < ApplicationController
  VALID_CONSTANTS = {
    "MovieSerializer" => MovieSerializer,
    "VoteSerializer" => VoteSerializer
  }.freeze

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
    render json: { errors: [ "Unauthorized" ] }, status: :unauthorized unless @current_user
  end

  def api_error(errors: [], status: "")
    render json: { errors: }, status:
  end

  def get_object_message(object, status)
    return "" if object.blank? || status.blank?

    "#{object.model_name.human} #{status.in?([ :created, 201 ]) ? 'created' : 'updated'}"
  end

  def get_serializer_class(object)
    object_serializer = "#{object.model_name.name}Serializer"
    return unless (serializer = VALID_CONSTANTS[object_serializer])

    serializer
  end

  def get_serialized_object(object, serializer)
    return object if object.is_a? Array

    serializer ||= get_serializer_class(object)
    return object unless serializer

    serializer.new(object).serializable_hash
  end

  def api_message(message: "", object: nil, serializer: nil, status: :ok)
    json = {
      message: message.blank? && !object.nil? ? get_object_message(object, status) : message
    }
    json = json.merge get_serialized_object(object, serializer) unless object.nil?
    render json:, status:
  end
end
