class CommentSerializer < ApplicationSerializer
  type 'comments'
  attributes :content

  belongs_to :author, serializer: AuthorSerializer
  has_many :comments
  has_many :attachments
end
