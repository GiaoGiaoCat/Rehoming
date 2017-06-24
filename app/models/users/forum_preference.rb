class Users::ForumPreference < ApplicationRecord
  self.table_name = 'user_forum_preferences'

  belongs_to :user, touch: true
  belongs_to :forum

  validates :forum_id, uniqueness: { scope: :user_id }

  scope :feed_allowed, -> { where(feed_allowed: true) }

  encrypted_id key: 'ncZVwd6xTBVjHa'
end
