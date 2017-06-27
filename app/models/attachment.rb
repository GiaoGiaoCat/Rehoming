class Attachment < ApplicationRecord
  IMAGE_CATEGORIES = {
    image: 10,
    video: 20
  }.freeze

  belongs_to :attachable, polymorphic: true, optional: true

  validates :category, :url, presence: true

  encrypted_id key: 'Kpovojv2sJzPnb'
  enum category: IMAGE_CATEGORIES

  def as_json(_options)
    { category: category, url: url }
  end
end
