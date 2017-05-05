class SessionSerializer < ApplicationSerializer
  type 'sessions'
  # attributes :auth_token
  # delegate :auth_token, to: :object

  def id
    object.user.id
  end
end
