class PostPolicy < ApplicationPolicy
  def pin_post?
    user.has_role?(:owner, record.forum) || user.has_role?(:admin, record.forum)
  end
  alias unpin_post? pin_post?
  alias favor_post? pin_post?
  alias unfavor_post? pin_post?
end
