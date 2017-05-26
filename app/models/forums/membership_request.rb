class Forums::MembershipRequest < ActiveType::Record[Forums::Membership]
  attribute :action, :string

  validates :action, presence: true, inclusion: { in: %w(accept reject ignore) }

  default_scope -> { pending }

  def update_status
    return false if invalid? || !respond_to?(action)
    send("#{action}!")
  end
end
