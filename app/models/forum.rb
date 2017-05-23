class Forum < ApplicationRecord
  obfuscate_id

  has_many :forum_memberships, class_name: 'Forums::Membership', foreign_key: 'forum_id'
  has_many :users, through: :forum_memberships
  has_many :posts

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

  encrypted_id key: 'vzmvXdcqWTVa6C'

  validates :name, presence: true
  validates :category, presence: true
end
