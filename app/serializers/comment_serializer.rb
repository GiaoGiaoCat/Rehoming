class CommentSerializer < ApplicationSerializer
  type 'comments'
  attributes :content

  belongs_to :user
  has_many :comments
  has_many :attachments
end
