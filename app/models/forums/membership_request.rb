class Forums::MembershipRequest < ActiveType::Record[Forums::Membership]
  attribute :invitation_token
  # extends ...................................................................
  # includes ..................................................................
  # constants .................................................................
  # relationships .............................................................

  # validations ...............................................................
  validates :action, presence: true, inclusion: { in: %w(accept reject ignore) }, allow_blank: true
  validate :ensure_invitation_token

  # callbacks .................................................................
  before_save :auto_approval, unless: :membership_approval_needed?, if: :pending?
  before_save :set_collaborator

  # scopes ....................................................................
  default_scope -> { pending }

  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  attribute :action, :string
  delegate :membership_approval_needed?, to: :forum

  # class methods .............................................................
  def self.policy_class
    Forums::MembershipRequestPolicy
  end

  # public instance methods ...................................................
  def update_status
    return false if invalid? || !respond_to?(action)
    send("#{action}!")
  end

  # protected instance methods ................................................

  # private instance methods ..................................................
  private

  def auto_approval
    accept
  end

  def set_as_collaborator
    return if invitation_token.blank?
    user.add_role :collaborator, forum
    invitation.used_by(user)
  end

  def ensure_invitation_token
    return if invitation_token.blank? || invitation_token_available?
    errors :invitation_token, :invalid
  end

  def invitation_token_available?
    invitation_token.present? && invitation.present?
  end

  def invitation
    @invitation ||= Forums::Invitation.find_by(forum: forum, token: invitation_token, accepted_at: nil)
  end
end
