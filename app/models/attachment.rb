class Attachment < ApplicationRecord
  IMAGE_CATEGORIES = {
    image: 10,
    video: 20
  }.freeze

  belongs_to :attachable, polymorphic: true, optional: true
  belongs_to :forum

  validates :category, :url, presence: true

  before_validation :ensure_forum

  encrypted_id key: 'Kpovojv2sJzPnb'
  enum category: IMAGE_CATEGORIES
  counter_culture :forum, column_name: proc { |attachment| "#{attachment.category}_attachments_count" }

  def as_json(_options)
    { category: category, url: url }
  end

  private

  def ensure_forum
    self.forum = attachable.forum
  end
end
