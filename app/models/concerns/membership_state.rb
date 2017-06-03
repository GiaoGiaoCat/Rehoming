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
      archived:  70,
      exited:    80
    }

    aasm column: :status, enum: true do
      state :pending, initial: true
      state :rejected, :ignored, :blocked, :active, :lapsed, :suspended, :archived, :exited

      event :accept, after: :ensure_preference do
        transitions from: %i(pending exited), to: :active
      end

      event :reject do
        transitions from: :pending, to: :rejected
      end

      event :ignore do
        transitions from: %i(pending exited), to: :ignored
      end

      event :block do
        transitions from: :active, to: :blocked
      end

      event :quit do
        transitions from: :active, to: :exited
      end

      event :rejoin do
        transitions from: :exited, to: :active
      end

      event :pend do
        transitions from: :rejected, to: :pending
      end

      event :unblock do
        transitions from: :blocked, to: :active
      end
    end
  end

  private

  def ensure_preference
    preference = forum_preferences.find_by(forum: forum)
    forum_preferences.create(forum: forum, nickname: user.nickname) unless preference
  end
end
