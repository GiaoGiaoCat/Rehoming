class Forums::Form < ActiveType::Record[Forum]
  attribute :owner

  validates :owner, presence: true

  after_create :ensure_owner

  private

  def ensure_owner
    owner.join_forum(self)
    owner.add_role :moderator, becomes(Forum)
  end
end
