class Forums::MembershipRequest < ActiveType::Record[Forums::Membership]
  attribute :action, :string

  validates :action, presence: true, inclusion: { in: %w(accept reject ignore) }, allow_blank: true

  before_create :auto_approval, unless: :membership_approval_needed?

  delegate :membership_approval_needed?, to: :forum

  def update_status
    return false if invalid? || !respond_to?(action)
    send("#{action}!")
  end

  private

  def auto_approval
    accept
  end
end
