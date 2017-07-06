class User < ApplicationRecord
  rolify

  action_store :like, :post, counter_cache: true
  action_store :like, :comment, counter_cache: true

  include ActsAsFavorable::Favoriter
  include ActsAsPinable::Piner
  include ActsAsRecommendable::Recommender
  include Redis::Objects

  has_many :posts
  has_many :favorite_posts, through: :favorites, source: :favorable, source_type: 'Post'
  has_many :forum_memberships, class_name: 'Forums::Membership', foreign_key: 'user_id'
  has_many :forums, -> { merge(Forums::Membership.active) }, through: :forum_memberships
  has_many :membership_requests, class_name: 'Forums::MembershipRequest', foreign_key: 'user_id'
  has_many :forum_preferences, class_name: 'Users::ForumPreference'

  validates :unionid, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :headimgurl, presence: true

  scope :blocked, -> { joins(:forum_memberships).merge(Forums::Membership.blocked) }
  scope :available, -> { joins(:forum_memberships).merge(Forums::Membership.available) }
  scope :feed_allowed, -> { joins(:forum_preferences).merge(Users::ForumPreference.feed_allowed) }
  scope :by_filter, ->(filter) { blocked if filter == 'blocked' }

  encrypted_id key: 'gaeexiHdLTQ8Fg'
  serialize :raw_info, Hash
  counter :feeds_count
  list :feeds

  def join_forum(forum)
    rejoin_membership_or_create_membership_request(forum)
  end

  def quit_forum(forum)
    exit_membership(forum)
  end

  def membership_by_forum(forum)
    forum_memberships.find_by(forum: forum)
  end

  def forum_nickname(forum)
    forum_membership = membership_by_forum(forum)
    forum_membership&.nickname || nickname
  end

  def role_names_by_forum(forum)
    roles.where(resource: forum).map(&:name)
  end

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
