module SupportMethod
  extend ActiveSupport::Concern

  private

  def load_parent
    resource, id = request.path.split('/')[1, 2]
    @parent ||= resource.singularize.classify.constantize.find(id)
  end

  def pagination_number
    params[:page].blank? ? 1 : params[:page][:number]
  end

  def explicit_serializer(resources, options)
    serializer_options = base_options.merge(options)
    ActiveModelSerializers::SerializableResource.new(resources, serializer_options)
  end

  def base_options
    options = { serialization_context: ActiveModelSerializers::SerializationContext.new(request) }
    if respond_to?(:view_variables, true)
      options[:scope] = view_variables
      options[:scope_name] = :view_variables
    end
    options
  end

  def redis
    Redis.current
  end
end
