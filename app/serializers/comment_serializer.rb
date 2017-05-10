class CommentSerializer < ApplicationSerializer
  type 'comments'
  attributes :content, :image_url

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
end
