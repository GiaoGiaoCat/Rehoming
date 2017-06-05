class Forums::InvitationPolicy < ApplicationPolicy
  def create?
    user.has_role? :owner, record.forum
  end
end
