class Post < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  include ActsAsLikeable::Likeable
  include ActsAsFavorable::Favorable
  # constants .................................................................
  # related macros ............................................................
  # relationships .............................................................
  belongs_to :group
  belongs_to :user
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable
  # has_many :latest_comments, as: :commentable, -> { limit(5) }
  has_many :latest_comments, -> { limit(5) }, as: :commentable, class_name: 'Comment'
  # validations ...............................................................
  validates :content, presence: true, length: { in: 1..10_000 }
  validate :images_limitation, :video_limitation
  # callbacks .................................................................
  # scopes ....................................................................
  # other macros (like devise's) ..............................................
  accepts_nested_attributes_for :attachments
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
