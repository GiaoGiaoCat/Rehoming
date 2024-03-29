class Roles::BecomeCollaboratorService < ApplicationService
  attribute :invitation_token, :string
  attribute :user_id, :integer
  attribute :invitation_id, :integer

  belongs_to :user
  belongs_to :invitation, class_name: 'Forums::Invitation', optional: true

  validates :invitation_token, presence: true
  validate :ensure_invitation_is_available

  before_save :ensure_invitation
  before_save :ensure_membership_request
  before_save :auto_approval_membership_request

  delegate :forum, to: :invitation

  private

  def perform
    return if user.has_role?(:moderator, forum) || user.has_role?(:collaborator, forum)
    user.add_role(:collaborator, forum)
    invitation.used_by(user)
  end

  def ensure_invitation_is_available
    @invitation = Forums::Invitation.available.find_by(token: invitation_token)
    errors.add :invitation_token, 'invitation token is unavailable.' unless @invitation
  end

  def ensure_invitation
    self.invitation ||= @invitation
  end

  def ensure_membership_request
    user.join_forum(forum)
  end

  def auto_approval_membership_request
    membership_request = Forums::MembershipRequest.find_by(forum: forum, user: user)
    membership_request&.accept!
  end
end
