class PostSerializer < ApplicationSerializer
  type 'posts'
  attributes :content

  belongs_to :author
  has_many :attachments
  has_many :comments
  has_many :likes
end
