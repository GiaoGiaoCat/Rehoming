class Forums::PostSerializer < ApplicationSerializer
  cache key: 'forum_post'

  attributes :content, :comments_count
  attribute :sticky, key: :pinned

  belongs_to :forum_for_serializer, key: :forum
  belongs_to :author
  has_many :attachments
  has_many :comments do
    object.comments.by_user(scope[:current_user], scope[:current_forum]).limit(5)
  end
  has_many :like_by_users, key: :likers
end
