class Forums::Preference < ApplicationRecord
  self.table_name = 'forum_preferences'

  belongs_to :forum

  validates :postable_roles, array: { inclusion: { in: Role::PERMISSIONS } }

  after_initialize :initialize_postable_roles

  serialize :postable_roles, Array
  encrypted_id key: 'RpfwGrdpL9KMpQ'

  def initialize_postable_roles
    self.postable_roles ||= []
  end
end
