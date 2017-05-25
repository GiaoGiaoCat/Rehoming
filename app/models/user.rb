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
  has_many :forum_memberships, class_name: 'Forums::Membership', foreign_key: 'user_id'
  has_many :forums, through: :forum_memberships
  has_many :forum_preferences, class_name: 'Users::ForumPreference'
  # validations ...............................................................
  validates :unionid, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :headimgurl, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'gaeexiHdLTQ8Fg'
  serialize :raw_info, Hash
  # class methods .............................................................
  # public instance methods ...................................................
  def join_forum(forum)
    return if forums.include?(forum)
    forums.append forum
  end

  def quit_forum(forum)
    return unless forums.include?(forum)
    forums.delete forum
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
