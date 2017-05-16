class User < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  include ActsAsLikeable::Liker
  include ActsAsFavorable::Favoriter
  # constants .................................................................
  # related macros ............................................................
  serialize :raw_info, Hash
  # relationships .............................................................
  has_many :posts
  has_many :favorite_posts, through: :favorites, source: :favorable, source_type: 'Post'
  has_many :group_enrollments, class_name: 'Groups::Enrollment', foreign_key: 'user_id'
  has_many :groups, through: :group_enrollments
  # validations ...............................................................
  validates :unionid, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :headimgurl, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # other macros (like devise's) ..............................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
