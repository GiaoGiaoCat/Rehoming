class Forums::Members::AsAdminPolicy < ApplicationPolicy
  def create?
    # 只有圈主才可以设置/取消一个成员的管理员权限
    user.has_role? :owner, record.forum
  end

  alias destroy? create?
end
