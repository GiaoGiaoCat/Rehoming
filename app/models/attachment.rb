class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true

  validates :category, :url, presence: true

  enum category: {
    image: 10,
    video: 20
  }
end
