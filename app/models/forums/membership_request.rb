class Forums::MembershipRequest < ActiveType::Record[Forums::Membership]
  validates :action, presence: true, inclusion: { in: %w(accept reject ignore) }, allow_blank: true

  after_save :auto_approval, unless: :membership_approval_needed?, if: :pending?

  default_scope -> { pending }

  attribute :action, :string
  delegate :membership_approval_needed?, to: :forum

  def self.policy_class
    Forums::MembershipRequestPolicy
  end

  def update_status
    return false if invalid? || !respond_to?(action)
    send("#{action}!")
  end

  private

  def auto_approval
    accept!
  end
end
