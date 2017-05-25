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
  has_many :forum_memberships, class_name: 'Forums::Membership', foreign_key: 'forum_id'
  has_many :membership_requests, class_name: 'Forums::MembershipRequest', foreign_key: 'forum_id'
  has_many :users, through: :forum_memberships
  has_many :posts
  # validations ...............................................................
  validates :name, presence: true
  validates :category, presence: true
  # callbacks .................................................................
  after_create :ensure_preference
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'vzmvXdcqWTVa6C'
  # class methods .............................................................
  # public instance methods ...................................................
  def members
    preference.member_list_protected? ? nil : users
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def ensure_preference
    create_preference
  end
end
