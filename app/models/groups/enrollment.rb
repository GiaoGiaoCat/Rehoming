class Groups::Enrollment < ApplicationRecord
  self.table_name = 'group_enrollments'

  belongs_to :user
  belongs_to :group

  enum role: {
    quanzhu:         10, # 圈主
    jiabin:          20, # 嘉宾
    guanliyuan:      30, # 管理员
    putongchengyuan: 40, # 普通成员
    lahei:           50  # 拉黑
  }
end
