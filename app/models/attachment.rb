class Attachment < ApplicationRecord
  belongs_to :post

  validates_presence_of :category, :url

  enum category: {
    image: 10,
    video: 20
  }
end
