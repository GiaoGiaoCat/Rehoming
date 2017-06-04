class Forums::Form < ActiveType::Record[Forum]
  attribute :owner

  validates :owner, presence: true

  after_create :ensure_owner

  private

  def ensure_owner
    owner.add_role :owner, becomes(Forum)
  end
end
