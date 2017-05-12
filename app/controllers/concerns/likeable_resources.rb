module LikeableResources
  extend ActiveSupport::Concern

  module ClassMethods
    def likeable_resources(options = {})
      cattr_accessor :action
      self.action = options[:action].to_sym || :like
    end
  end

  def create
    load_likeable
    build_operation_obj
    execute_operation
    head :created
  end

  private

  def load_likeable
    resource, id = request.path.split('/')[1, 2]
    @likeable = resource.singularize.classify.constantize.find(id)
  end

  def build_operation_obj
    @operation_obj =
      case self.class.action
      when :like
        current_user.likes.build(likeable: @likeable)
      when :dislike
        current_user.likes.where(likeable: @likeable)
      end
  end

  def execute_operation
    case self.class.action.to_sym
    when :like
      @operation_obj.save
    when :dislike
      @operation_obj.destroy_all
    end
  end
end
