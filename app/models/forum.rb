class Forum < ApplicationRecord
  # extends ...................................................................
  obfuscate_id
  # includes ..................................................................

  # constants .................................................................
  enum category: {
    wenyi:    10,
    keji:     20,
    shishang: 30,
    yule:     40,
    jingji:   50,
    jiaoyu:   60,
    jiankang: 70,
    shenghuo: 80
  }

  # relationships .............................................................
  has_one :preference, class_name: 'Forums::Preference'
  has_many :memberships, class_name: 'Forums::Membership', foreign_key: 'forum_id'
  has_many :membership_requests, class_name: 'Forums::MembershipRequest', foreign_key: 'forum_id'
  has_many :members, class_name: 'User', through: :memberships, source: :user
  has_many :posts

  # validations ...............................................................
  validates :name, presence: true
  validates :category, presence: true

  # callbacks .................................................................
  after_create :ensure_preference

  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'vzmvXdcqWTVa6C'
  delegate :membership_approval_needed?, :member_list_protected?, to: :preference

  # class methods .............................................................

  # public instance methods ...................................................
  def visible_members
    member_list_protected? ? nil : members
  end

  # protected instance methods ................................................

  # private instance methods ..................................................
  private

  def ensure_preference
    create_preference
  end
end
