class ForumPolicy < ApplicationPolicy
  def view_membership_requests?
    user.has_role?(:owner, record)
  end

  def view_blocked_members?
    user.has_role?(:owner, record) || user.has_role?(:admin, record)
  end

  %i(create_blocked_member? destroy_blocked_member? destroy_member? manage_recommend? manage_pin?).each do |new_method|
    alias_method new_method, :view_blocked_members?
  end
end
