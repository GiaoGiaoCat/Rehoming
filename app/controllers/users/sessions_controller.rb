class Users::SessionsController < ApplicationController
  skip_before_action :authenticate_request!

  def create
    @session = Users::SignIn.new(session_params)
    if @session.save
      render json: @session, status: :created, serializer: SessionSerializer
    else
      render_error_msg(@session, :access_token, :userinfo, :user_id)
    end
  end

  private

  def session_params
    params.require(:data).require(:attributes).permit(:code)
  end
end
