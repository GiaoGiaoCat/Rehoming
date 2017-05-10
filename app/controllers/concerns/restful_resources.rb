module RestfulResources
  extend ActiveSupport::Concern

  included do
    before_action :load_resource, only: %i(show edit update destroy)
  end

  module ClassMethods
    def restful_resources(options = {})
      cattr_accessor :resource_name
      self.resource_name = options[:resource_name]
    end
  end

  def index
    load_resources
  end

  def new
    build_resource
  end

  def create
    build_resource
    save_resource_and_render
  end

  def update
    build_resource
    save_resource
  end

  def destroy
    destroy_resource
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def load_resources
    resources = instance_variable_get("@#{self.class.resource_name.to_s.pluralize}")
    resources ||= resource_scope.page(params[:page])
    instance_variable_set("@#{self.class.resource_name.to_s.pluralize}", resources)
  end

  def load_resource
    resource = instance_variable_get("@#{self.class.resource_name}")
    resource ||= resource_scope.find(params[:id])
    instance_variable_set("@#{self.class.resource_name}", resource)
  end

  def build_resource
    resource = instance_variable_get("@#{self.class.resource_name}")
    resource ||= resource_scope.new
    resource.attributes = resource_params
    instance_variable_set("@#{self.class.resource_name}", resource)
  end

  def save_resource_and_render
    resource = instance_variable_get("@#{self.class.resource_name}")
    if resource.save
      render json: resource
    else
      render json: resource.errors.full_messages, status: :bad_request
    end
  end

  def destroy_resource
    resource = instance_variable_get("@#{self.class.resource_name}")
    resource.destroy
  end

  def resource_scope
    self.class.resource_name.to_s.classify.constantize
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def resource_params
    raise NotImplementedError, 'Must be implemented by who mixins me.'
  end
end
