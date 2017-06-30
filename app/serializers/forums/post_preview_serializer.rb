class Forums::PostPreviewSerializer < ApplicationSerializer
  cache key: 'forum_post_preview'

  attributes :content

  belongs_to :forum_for_serializer, key: :forum
  belongs_to :author
  has_many :attachments

  class ForumSerializer < ApplicationSerializer
    cache key: 'forum_preview'
    attributes :name, :description, :cover, :background_color, :created_at
    attributes :posts_count, :image_attachments_count, :video_attachments_count
    attribute :members_count

    def members_count
      object.members.available.count
    end
  end
end
