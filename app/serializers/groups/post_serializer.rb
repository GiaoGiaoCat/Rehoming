class Groups::PostSerializer < ApplicationSerializer
  type 'posts'
  attributes :content

  belongs_to :author, serializer: AuthorSerializer
  has_many :attachments
  has_many :latest_comments, key: :comments
end
