class User < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  include ActsAsLikeable::Liker
  include ActsAsFavorable::Favoriter
  include ActsAsPinable::Piner
  include ActsAsRecommendable::Recommender
  # constants .................................................................
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
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  serialize :raw_info, Hash
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
