class Group < ApplicationRecord
  obfuscate_id

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
