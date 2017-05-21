class Groups::PostSerializer < ApplicationSerializer
  type 'posts'
  attributes :content

  belongs_to :author
  has_many :attachments
  has_many :latest_comments, key: :comments
  has_many :likes
end
