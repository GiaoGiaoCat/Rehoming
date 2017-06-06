class Forums::Preference < ApplicationRecord
  # table name ................................................................
  self.table_name = 'forum_preferences'
  # extends ...................................................................
  # includes ..................................................................
  # constants .................................................................
  # relationships .............................................................
  belongs_to :forum
  # validations ...............................................................
  validates :postable_roles, presence: true
  validate :ensure_valid_roles
  # callbacks .................................................................
  after_initialize :initialize_postable_roles
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  serialize :postable_roles, Array
  encrypted_id key: 'RpfwGrdpL9KMpQ'
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def initialize_postable_roles
    self.postable_roles = Forums::Membership.roles.values if new_record?
  end

  def ensure_valid_roles
    return if postable_roles.all? { |r| r.in?(Forums::Membership.roles.values) }
    errors.add :postable_roles, '可发帖的用户组数据非法'
  end
end
