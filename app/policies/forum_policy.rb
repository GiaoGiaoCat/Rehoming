class ForumPolicy < ApplicationPolicy
  def view_blocked_members?
    # 圈主、管理员才可以查看被拉黑的成员列表
    user.has_role?(:owner, record) || user.has_role?(:admin, record)
  end
  alias create_blocked_member? view_blocked_members?
  alias destroy_blocked_member? view_blocked_members?
end
