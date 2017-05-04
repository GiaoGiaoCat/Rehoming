class Attachment < ApplicationRecord
  belongs_to :post

  enum category: {
    image: 10,
    video: 20
  }
end
