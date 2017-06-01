class Forums::PostSerializer < ApplicationSerializer
  type 'posts'
  attributes :content

  belongs_to :author
  has_many :attachments
  has_many :comments do
    if scope[:current_user] && scope[:current_forum]
      object.comments.by_user(scope[:current_user], scope[:current_forum]).limit(5)
    else
      limit(5)
    end
  end
  has_many :likes
end
