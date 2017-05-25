module PreferenceResources
  extend ActiveSupport::Concern

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
    raise NotImplementedError, 'Must be implemented by who mixins me.'
  end

  def preference_attrs
    raise NotImplementedError, 'Must be implemented by who mixins me.'
  end

  def preference_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: preference_attrs)
  end
end
