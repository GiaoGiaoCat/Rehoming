class PostSerializer < ApplicationSerializer
  cache key: 'post'
  attributes :content, :comments_count
  attribute :sticky, key: :pinned

  belongs_to :author
  has_many :attachments
  has_many :comments do
    object.comments.by_user(scope[:current_user], scope[:current_forum]).limit(25)
  end
  has_many :likes
end
