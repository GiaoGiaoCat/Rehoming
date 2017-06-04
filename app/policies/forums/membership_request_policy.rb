class Forums::MembershipRequestPolicy < ApplicationPolicy
  def update?
    user.has_role? :owner, record.forum
  end
end
