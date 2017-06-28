class Users::ForumSerializer < ApplicationSerializer
  cache key: 'user_forum'
  attributes :name, :description, :cover, :background_color, :posts_count
end
