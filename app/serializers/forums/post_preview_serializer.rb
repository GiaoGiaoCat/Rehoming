class Forums::PostPreviewSerializer < ApplicationSerializer
  cache key: 'forum_post_preview'

  attributes :content

  belongs_to :forum_for_serializer, key: :forum
  belongs_to :author
  has_many :attachments

  class ForumSerializer < ApplicationSerializer
    cache key: 'forum_preview'
    attributes :name, :description, :cover, :background_color, :posts_count
  end
end
