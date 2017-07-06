class Post < ApplicationRecord
  acts_as_paranoid

  include ActsAsFavorable::Favorable
  include ActsAsPinable::Pinable
  include ActsAsRecommendable::Recommendable
  include ScopeByUser

  # XXX: forum's id is integer in the serializer of post relationships, that's not correct
  belongs_to :forum_for_serializer, class_name: 'Forum', foreign_key: :forum_id
  belongs_to :forum
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable

  validates :content, presence: true, length: { in: 1..10_000 }
  validate :images_limitation, :video_limitation

  scope :by_filter, ->(filter) { by_recommended if filter == 'recommended' }

  accepts_nested_attributes_for :attachments
  encrypted_id key: 'kwXKxc3zRH3UFz'
  counter_culture :author
  counter_culture :forum

  private

  def images_limitation
    errors.add :base, :too_many_images if attachments.select(&:image?).count > 9
  end

  def video_limitation
    errors.add :base, :too_many_videos if attachments.select(&:video?).count > 1
  end
end
