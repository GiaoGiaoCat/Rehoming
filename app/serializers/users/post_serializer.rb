class Users::PostSerializer < ApplicationSerializer
  type 'posts'
  attributes :content

  belongs_to :forum
  has_many :attachments
end
