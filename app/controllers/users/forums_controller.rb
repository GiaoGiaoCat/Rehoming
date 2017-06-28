class Users::ForumsController < ApplicationController
  def index
    render json: current_user.forums
  end
end
