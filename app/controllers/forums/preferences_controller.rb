class Forums::PreferencesController < ApplicationController
  include PreferenceResources

  private

  def build_preference
    @preference = forum.preference
    @preference.attributes = preference_params
  end

  def preference_attrs
    %i(
      member_list_protected postable_until_tomorrow shared_post_allowed
      direct_message_allowed membership_approval_needed postable_roles
    )
  end
end
