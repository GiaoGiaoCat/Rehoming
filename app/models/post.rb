class Post < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :attachments
  has_many :comments, as: :commentable

  validates :content, presence: true, length: { in: 1..10_000 }
  validate :images_limitation, :video_limitation

  accepts_nested_attributes_for :attachments

  private

  def images_limitation
    errors.add :base, :too_many_images if attachments.select(&:image?).count > 9
  end

  def video_limitation
    errors.add :base, :too_many_videos if attachments.select(&:video?).count > 1
  end
end
