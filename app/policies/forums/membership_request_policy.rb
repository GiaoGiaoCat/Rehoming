class Forums::MembershipRequestPolicy < ApplicationPolicy
  def update?
    user.has_role? :moderator, record.forum
  end
end
