class Users::PostSerializer < ApplicationSerializer
  type 'posts'
  attributes :content

  belongs_to :group
  has_many :attachments
end
