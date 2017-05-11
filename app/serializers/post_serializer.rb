class PostSerializer < ApplicationSerializer
  type 'posts'
  attributes :content

  has_many :attachments
  has_many :comments
end
