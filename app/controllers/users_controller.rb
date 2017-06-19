class UsersController < ApplicationController
  def show
    render json: @current_user
  end

  def update
    build_current_user
    if @current_user.save
      head :created
    else
      render json: @current_user.errors.messages, status: :bad_request
    end
  end

  private

  def build_current_user
    @current_user.attributes = user_params
  end

  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %w(nickname headimgurl))
  end
end
