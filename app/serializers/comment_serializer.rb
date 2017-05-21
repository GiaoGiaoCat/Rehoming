class CommentSerializer < ApplicationSerializer
  type 'comments'
  attributes :content

  belongs_to :author
  has_many :comments
  has_many :attachments
end
