class Memberships::BecomeCollaboratorService < ApplicationService
  attribute :invitation_token, :string
  attribute :user_id
  attribute :invitation_id

  belongs_to :user
  belongs_to :invitation, class_name: 'Forums::Invitation', optional: true

  validates :user, presence: true
  validates :invitation_token, presence: true
  validate :ensure_invitation_is_available

  before_save :ensure_invitation
  before_save :ensure_membership_request
  before_save :auto_approval_membership_request
  after_save :act_as_collaborator

  delegate :forum, to: :invitation

  private

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

  def act_as_collaborator
    user.add_role :collaborator, forum
    invitation.used_by(user)
  end
end
