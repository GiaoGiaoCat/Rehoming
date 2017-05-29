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
  has_many :forums, -> { merge(Forums::Membership.active) }, through: :forum_memberships
  has_many :membership_requests, class_name: 'Forums::MembershipRequest', foreign_key: 'user_id'
  has_many :forum_preferences, class_name: 'Users::ForumPreference'
  has_many :feeds, as: :targetable
  # validations ...............................................................
  validates :unionid, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :headimgurl, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :by_filter, ->(filter) { joins(:forum_memberships).merge(Forums::Membership.blocked) if filter == 'blocked' }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'gaeexiHdLTQ8Fg'
  serialize :raw_info, Hash
  # class methods .............................................................
  # public instance methods ...................................................
  def join_forum(forum)
    rejoin_membership_or_create_membership_request(forum)
  end

  def quit_forum(forum)
    exit_membership(forum)
  end

  def membership_by_forum(forum)
    forum_memberships.find_by(forum: forum)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def rejoin_membership_or_create_membership_request(forum)
    forum_membership = membership_by_forum(forum)
    return membership_requests.create(forum: forum) unless forum_membership
    forum_membership.join_again
  end

  def exit_membership(forum)
    membership = membership_by_forum(forum)
    membership.quit! if membership&.active?
  end
end
