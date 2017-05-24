class Forums::PreferencesController < ApplicationController
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
    @preference = forum.preference
    @preference.attributes = preference_params
  end

  def preference_params
    attrs = %i(
      member_list_protected postable_until_tomorrow shared_post_allowed
      direct_message_allowed membership_approval_needed postable_role
    )
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: attrs)
  end
end
