class PostSerializer < ApplicationSerializer
  attributes :content
  attribute :sticky, key: :pinned

  belongs_to :author
  has_many :attachments
  has_many :comments do
    if scope[:current_user] && scope[:current_forum]
      object.comments.by_user(scope[:current_user], scope[:current_forum])
    end
  end
  has_many :likes
end
