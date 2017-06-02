class Forums::Form < ActiveType::Record[Forum]
  attribute :user

  validates :user, presence: true

  after_create :ensure_owner

  private

  def ensure_owner
    user.add_role :owner, becomes(Forum)
  end
end
