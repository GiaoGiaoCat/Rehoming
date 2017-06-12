module ScopeByUser
  extend ActiveSupport::Concern

  included do
    has_one :membership, -> { joins(:forum) },
            class_name:  'Forums::Membership',
            foreign_key: 'user_id',
            primary_key: 'user_id'

    scope :by_user, ->(user, forum) { user.membership_by_forum(forum).blocked? ? with_blocked(user) : active }
    scope :active, -> { joins(:membership).merge(Forums::Membership.active) }
    scope :with_blocked, lambda { |user|
      active.or(
        joins(:membership).where(forum_memberships: { status: Forums::Membership::STATE_BLOCKED, user_id: user.id })
      )
    }
  end
end
