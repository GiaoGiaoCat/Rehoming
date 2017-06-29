class Forums::PostPreviewSerializer < ApplicationSerializer
  cache key: 'forum_post_preview'

  attributes :content

  belongs_to :forum
  belongs_to :author
  has_many :attachments
  has_many :comments do
    object.comments.limit(5)
  end
end
