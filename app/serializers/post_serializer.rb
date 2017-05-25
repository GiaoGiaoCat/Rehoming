class PostSerializer < ApplicationSerializer

  attributes :content
  attribute :sticky, key: :pinned

  belongs_to :author
  has_many :attachments
  has_many :comments
  has_many :likes
end
