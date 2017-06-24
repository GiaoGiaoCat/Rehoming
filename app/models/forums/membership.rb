class Forums::Membership < ApplicationRecord
  self.table_name = 'forum_memberships'

  include MembershipState

  belongs_to :user, touch: true
  belongs_to :forum

  validates :forum_id, uniqueness: { scope: :user_id }

  scope :available, -> { where(status: [STATE_ACTIVE, STATE_BLOCKED]) }

  encrypted_id key: 'MhnjnhNQZxubL9'
  delegate :forum_preferences, to: :user
  delegate :nickname, to: :preference

  def preference
    forum_preferences.find_by(forum: forum)
  end

  def join_again
    # ignore request when status is ignored or active
    pend! if rejected?
    rejoin! if exited?
  end
end
