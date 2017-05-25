class Users::ForumPreferencesController < ApplicationController
  def update
    build_preference
    if @preference.save
      render json: @preference
    else
      render json: @preference.errors.messages, status: :bad_request
    end
  end

  private

  def forum
    @forum = Forum.find(params[:forum_id])
  end

  def build_preference
    @preference = @current_user.forum_preferences.find_by(forum: forum)
    @preference.attributes = preference_params
  end

  def preference_params
    attrs = %i(nickname follow_topics_on_mention)
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: attrs)
  end
end
