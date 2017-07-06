class Comment < ApplicationRecord
  acts_as_paranoid

  include ScopeByUser

  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :forum
  belongs_to :replied_user, class_name: 'User', foreign_key: 'replied_user_id', required: false
  has_many :attachments, as: :attachable

  validates :forum_id, presence: true
  validates :commentable, presence: true
  validates :content, presence: { if: proc { |cm| cm.attachments.empty? } }
  validate :images_limitation

  before_validation :ensure_forum

  accepts_nested_attributes_for :attachments
  encrypted_id key: 'MHnwUHbY6KPhow'
  counter_culture :commentable, column_name: 'comments_count'

  private

  def images_limitation
    errors.add :base, :too_many_images if attachments.select(&:image?).count > 1
  end

  def ensure_forum
    return unless commentable
    self.forum ||= commentable.forum
  end
end
