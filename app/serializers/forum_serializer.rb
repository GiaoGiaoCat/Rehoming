class ForumSerializer < ApplicationSerializer
  cache key: 'forum'
  attributes :name, :description, :cover, :background_color, :posts_count

  has_one :preference
end
