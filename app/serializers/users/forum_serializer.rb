class Users::ForumSerializer < ApplicationSerializer
  cache key: 'user_forum'
  attributes :name
end
