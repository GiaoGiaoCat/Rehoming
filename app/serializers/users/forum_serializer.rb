class Users::ForumSerializer < ApplicationSerializer
  cache key: 'user_forum'
  attributes :name, :description, :cover, :background_color, :created_at
  attributes :posts_count, :image_attachments_count, :video_attachments_count
  attribute :members_count

  def members_count
    object.members.available.count
  end
end
