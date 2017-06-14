module MembershipState
  extend ActiveSupport::Concern

  STATUS = {
    pending:   0,
    rejected:  10,
    ignored:   20,
    blocked:   30,
    active:    40,
    lapsed:    50,
    suspended: 60,
    archived:  70,
    exited:    80
  }.freeze

  included do
    include AASM

    enum status: STATUS

    aasm column: :status, enum: true do
      state :pending, initial: true
      state :rejected, :ignored, :blocked, :active, :lapsed, :suspended, :archived, :exited

      event :accept, after: %i[ensure_preference touch_accepted_at] do
        transitions from: %i(pending exited), to: :active
      end
      event :reject { transitions from: :pending, to: :rejected }
      event :ignore { transitions from: %i(pending exited), to: :ignored }
      event :block { transitions from: :active, to: :blocked }
      event :quit { transitions from: :active, to: :exited }
      event :rejoin { transitions from: :exited, to: :active }
      event :pend { transitions from: :rejected, to: :pending }
      event :unblock { transitions from: :blocked, to: :active }
    end
  end

  private

  def touch_accepted_at
    touch(:accepted_at)
  end

  def ensure_preference
    preference = forum_preferences.find_by(forum: forum)
    forum_preferences.create(forum: forum, nickname: user.nickname) unless preference
  end
end
