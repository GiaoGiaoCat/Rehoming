class Users::PostSerializer < ApplicationSerializer
  cache key: 'user_post'
  attributes :content

  belongs_to :forum_for_serializer, key: :forum
  has_many :attachments

  class ForumSerializer < ApplicationSerializer
    cache key: 'user_post_forum'
    attributes :name
  end
end
