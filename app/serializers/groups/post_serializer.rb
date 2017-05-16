class Groups::PostSerializer < ApplicationSerializer
  type 'posts'
  attributes :content

  has_many :attachments
  has_many :latest_comments, key: :comments, serializer: CommentSerializer
end
