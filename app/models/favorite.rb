class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favorable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i(favorable_id favorable_type) }

  encrypted_id key: 'P6jnaXZpyQBQuX'
  counter_culture :user
end
