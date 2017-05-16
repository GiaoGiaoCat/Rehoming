class Group < ApplicationRecord
  obfuscate_id

  has_many :group_enrollments, class_name: 'Groups::Enrollment', foreign_key: 'group_id'
  has_many :users, through: :group_enrollments
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

  validates :title, presence: true
  validates :category, presence: true
end
