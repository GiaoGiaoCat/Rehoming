class Forums::CreateService < ActiveType::Record[Forum]
  attribute :moderator

  validates :moderator, presence: true

  after_create :ensure_moderator

  private

  def ensure_moderator
    moderator.join_forum(self)
    moderator.add_role :moderator, becomes(Forum)
  end
end
