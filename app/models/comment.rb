class Comment < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  include ActsAsLikeable::Likeable
  include ScopeByUser
  # constants .................................................................
  # relationships .............................................................
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :forum
  belongs_to :replied_user, class_name: 'User', foreign_key: 'replied_user_id', required: false
  has_many :attachments, as: :attachable
  # validations ...............................................................
  validates :forum_id, presence: true
  validates :commentable, presence: true
  validates :content, presence: { if: proc { |cm| cm.attachments.empty? } }
  validate :images_limitation
  # callbacks .................................................................
  before_validation :ensure_forum
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  accepts_nested_attributes_for :attachments
  encrypted_id key: 'MHnwUHbY6KPhow'
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def images_limitation
    errors.add :base, :too_many_images if attachments.select(&:image?).count > 1
  end

  def ensure_forum
    return unless commentable
    self.forum ||= commentable.forum
  end
end
