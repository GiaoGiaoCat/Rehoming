class Attachment < ApplicationRecord
  belongs_to :post

  validates :category, :url, presence: true

  enum category: {
    image: 10,
    video: 20
  }
end
