class Comment < ApplicationRecord
  include ActsAsLikeable::Likeable

  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :user
  has_many :comments, as: :commentable
end
