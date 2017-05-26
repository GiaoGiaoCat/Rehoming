module MembershipState
  extend ActiveSupport::Concern

  included do
    include AASM

    enum status: {
      pending:   0,
      rejected:  10,
      ignored:   20,
      blocked:   30,
      active:    40,
      lapsed:    50,
      suspended: 60,
      archived:  70
    }

    aasm column: :status, enum: true do
      state :pending, initial: true
      state :rejected, :ignored, :blocked, :active, :lapsed, :suspended, :archived

      event :accept, after: :ensure_preference do
        transitions from: :pending, to: :active
      end

      event :reject do
        transitions from: :pending, to: :rejected
      end

      event :ignore do
        transitions from: :pending, to: :ignored
      end

      event :block do
        transitions from: :active, to: :blocked
      end
    end
  end

  private

  def ensure_preference
    forum_preferences.create(forum: forum, nickname: user.nickname)
  end
end
