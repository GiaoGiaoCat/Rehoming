class Forums::PreferenceSerializer < ApplicationSerializer
  cache key: 'forum_preference'

  attributes :member_list_protected, :postable_until_tomorrow, :shared_post_allowed, :direct_message_allowed
  attributes :membership_approval_needed, :postable_roles
end
