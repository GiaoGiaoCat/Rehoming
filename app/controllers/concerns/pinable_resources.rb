module PinableResources
  extend ActiveSupport::Concern

  module ClassMethods
    def pinable_resources(options = {})
      cattr_accessor :action
      self.action = options[:action].to_sym || :pin
    end
  end

  def create
    create_able_resource
  end

  private

  def verb_name
    :pin
  end

  def unverb_name
    :unpin
  end

  def build_operation_obj
    @operation_obj = Post.find(params[:post_id])
  end

  def execute_operation
    case self.class.action.to_sym
    when verb_name
      @current_user.pin(@operation_obj)
    when unverb_name
      @current_user.unpin(@operation_obj)
    end
  end
end
