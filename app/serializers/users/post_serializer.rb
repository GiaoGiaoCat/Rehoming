class Users::PostSerializer < ApplicationSerializer
  cache key: 'user_post'
  attributes :content

  belongs_to :forum
  has_many :attachments
end
