class Users::ForumPreferencesController < ApplicationController
  include PreferenceResources

  private

  def build_preference
    @preference = @current_user.forum_preferences.find_by(forum: forum)
    @preference.attributes = preference_params
  end

  def preference_attrs
    %i(nickname feed_allowed)
  end
end
