class Forums::InvitationPolicy < ApplicationPolicy
  def create?
    user.has_role? :moderator, record.forum
  end
end
