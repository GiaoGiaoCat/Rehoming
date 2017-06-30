class Users::FavoriteSerializer < ApplicationSerializer
  cache key: 'user_favorite'
  attributes :content

  belongs_to :forum, serializer: Users::ForumSerializer
  belongs_to :author
  has_many :attachments
end
