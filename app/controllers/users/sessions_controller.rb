class Users::SessionsController < ApplicationController
  before_action :load_development_session, if: -> { Rails.env.development? }
  skip_before_action :authenticate_request!

  def create
    @session = Users::SignInForm.new(session_params)
    if @session.save
      render json: @session.object, status: :created
    else
      render_error_msg(@session, :user, :userinfo)
    end
  end

  private

  def session_params
    params.require(:data).require(:attributes).permit(:code)
  end

  def load_development_session
    @session = Users::Session.create(user: @current_user)
    render json: @session, status: :created
  end
end
