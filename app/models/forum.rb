class Forum < ApplicationRecord
  acts_as_paranoid
  obfuscate_id
  resourcify

  CATEGORIES = {
    wenyi:    10, # 文艺
    keji:     20, # 科技
    shishang: 30, # 时尚
    yule:     40, # 娱乐
    jingji:   50, # 经济
    jiaoyu:   60, # 教育
    jiankang: 70, # 健康
    shenghuo: 80  # 生活
  }.freeze

  enum category: CATEGORIES

  has_one :preference, class_name: 'Forums::Preference'
  has_many :memberships, class_name: 'Forums::Membership', foreign_key: 'forum_id'
  has_many :membership_requests, class_name: 'Forums::MembershipRequest', foreign_key: 'forum_id'
  has_many :members, -> { available }, class_name: 'User', through: :memberships, source: :user
  has_many :blocked_members, -> { blocked }, class_name: 'User', through: :memberships, source: :user
  has_many :posts

  validates :name, presence: true
  validates :category, presence: true

  after_create :ensure_preference

  encrypted_id key: 'vzmvXdcqWTVa6C'
  delegate :membership_approval_needed?,
           :member_list_protected?,
           :postable_until_tomorrow?,
           :postable_roles,
           to: :preference

  def visible_members
    member_list_protected? ? nil : members
  end

  private

  def ensure_preference
    create_preference
  end
end
