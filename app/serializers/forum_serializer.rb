class ForumSerializer < ApplicationSerializer
  cache key: 'forum'
  attributes :name, :description, :cover, :background_color

  has_one :preference
end
