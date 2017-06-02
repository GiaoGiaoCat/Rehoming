class ForumPolicy < ApplicationPolicy
  def create?
    user.has_role? :owner, record.becomes(Forum)
  end

  alias destroy? create?
end
