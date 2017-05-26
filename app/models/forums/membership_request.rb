class Forums::MembershipRequest < ActiveType::Record[Forums::Membership]
  attribute :action, :string

  validates :action, presence: true, inclusion: { in: %w[accept reject ignore] }

  default_scope -> { pending }

  def save
    return false if invalid?
    persist!
  end

  private

  def persist!
    respond_to?(action) ? send(action) : false
  end
end
