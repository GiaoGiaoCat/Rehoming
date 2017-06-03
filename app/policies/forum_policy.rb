class ForumPolicy < ApplicationPolicy
  def view_membership_requests?
    user.has_role?(:owner, record)
  end

  def view_blocked_members?
    user.has_role?(:owner, record) || user.has_role?(:admin, record)
  end
  alias create_blocked_member? view_blocked_members?
  alias destroy_blocked_member? view_blocked_members?
end
