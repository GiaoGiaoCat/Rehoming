class Users::PostSerializer < ApplicationSerializer
  cache key: 'post'
  attributes :content

  belongs_to :forum
  has_many :attachments
end
