class Post < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  include ActsAsLikeable::Likeable
  include ActsAsFavorable::Favorable
  include ActsAsPinable::Pinable
  include ActsAsRecommendable::Recommendable
  # relationships .............................................................
  belongs_to :forum
  belongs_to :user
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable
  # has_many :latest_comments, as: :commentable, -> { limit(5) }
  has_many :latest_comments, -> { limit(5) }, as: :commentable, class_name: 'Comment'
  # validations ...............................................................
  validates :content, presence: true, length: { in: 1..10_000 }
  validate :images_limitation, :video_limitation
  validate :user_should_in_forum
  validate :postable_until_tomorrow
  # callbacks .................................................................
  # scopes ....................................................................
  scope :by_filter, ->(filter) { by_recommended if filter == 'recommended' }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  accepts_nested_attributes_for :attachments
  encrypted_id key: 'kwXKxc3zRH3UFz'
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def user_should_in_forum
    errors.add :base, :not_in_forum unless author_membership
  end

  def postable_until_tomorrow
    return unless forum.preference.postable_until_tomorrow
    errors.add :base, :postable_until_tomorrow if author_membership.created_at.next_day > Time.current
  end

  def images_limitation
    errors.add :base, :too_many_images if attachments.select(&:image?).count > 9
  end

  def video_limitation
    errors.add :base, :too_many_videos if attachments.select(&:video?).count > 1
  end

  def author_membership
    user.forum_memberships.find_by(forum: forum)
  end
end
