module AuthenticateRequest
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    attr_reader :current_user
  end

  protected

  def authenticate_request!
    return load_development_user if Rails.env.development?
    return invalid_authentication unless user_id_in_token?
    return invalid_authentication unless load_current_user
  rescue JWT::DecodeError
    invalid_authentication
  end

  # Returns 401 response. To handle malformed / invalid requests.
  def invalid_authentication
    render json: { error: 'Not Authenticated' }, status: :unauthorized
  end

  private

  def http_token
    @http_token ||=
      if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id]
  end

  # Sets the @current_user with the user_id from payload
  def load_current_user
    @current_user ||= User.find(auth_token[:user_id])
  end

  def load_development_user
    @current_user ||= User.first
  end
end
