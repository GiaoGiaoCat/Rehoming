class Roles::BecomeAdminService < ApplicationService
  attribute :forum_id, :integer
  attribute :user_id, :integer

  belongs_to :user
  belongs_to :forum

  validate :need_membership

  delegate :members, to: :forum

  private

  def perform
    return if user.has_role?(:moderator, forum)
    user.add_role(:admin, forum)
  end

  def need_membership
    errors.add :base, :need_membership unless members.include?(user)
  end
end
