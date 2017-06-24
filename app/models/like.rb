class Like < ApplicationRecord
  belongs_to :liker, class_name: 'User', foreign_key: :user_id
  belongs_to :likeable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i(likeable_id likeable_type) }

  encrypted_id key: '9edkXgYsCQDZfB'
end
