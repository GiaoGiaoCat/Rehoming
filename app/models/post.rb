class Post < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  include ActsAsLikeable::Likeable
  include ActsAsFavorable::Favorable
  include ActsAsPinable::Pinable
  include ActsAsRecommendable::Recommendable
  include ScopeByUser
  # relationships .............................................................
  belongs_to :forum
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable
  # validations ...............................................................
  validates :content, presence: true, length: { in: 1..10_000 }
  validate :images_limitation, :video_limitation
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

  def images_limitation
    errors.add :base, :too_many_images if attachments.select(&:image?).count > 9
  end

  def video_limitation
    errors.add :base, :too_many_videos if attachments.select(&:video?).count > 1
  end
end
