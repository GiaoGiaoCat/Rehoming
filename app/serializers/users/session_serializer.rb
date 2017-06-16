class Users::SessionSerializer < ApplicationSerializer
  type 'sessions'
  attributes :auth_token
end
