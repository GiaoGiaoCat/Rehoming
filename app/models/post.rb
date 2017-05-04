class Post < ApplicationRecord
  has_many :attachments

  validates :content, presence: true, length: { in: 1..10_000 }

  accepts_nested_attributes_for :attachments
end
