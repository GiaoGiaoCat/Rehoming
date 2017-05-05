class PostSerializer < ApplicationSerializer
  type 'posts'
  attributes :content

  has_many :attachments
end
