class CommentSerializer < ApplicationSerializer
  cache key: 'comment'

  attributes :content

  belongs_to :author
  has_many :attachments
end
