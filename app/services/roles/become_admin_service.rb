class Roles::BecomeAdminService < ApplicationService
  attribute :forum_id, :integer
  attribute :user_id, :integer

  belongs_to :user
  belongs_to :forum

  validate :need_membership

  after_save :act_as_administrator

  delegate :members, to: :forum

  private

  def need_membership
    errors.add :base, :need_membership unless members.include?(user)
  end

  def act_as_administrator
    return if user.has_role?(:moderator, forum)
    user.add_role(:admin, forum)
  end
end
