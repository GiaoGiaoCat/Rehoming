module LikeableResources
  extend ActiveSupport::Concern

  module ClassMethods
    def likeable_resources(options = {})
      cattr_accessor :action
      self.action = options[:action].to_sym || :like
    end
  end

  def create
    load_parent
    build_operation_obj
    execute_operation
    head :created
  end

  private

  def build_operation_obj
    @operation_obj =
      case self.class.action
      when :like
        current_user.likes.build(likeable: @parent)
      when :dislike
        current_user.likes.where(likeable: @parent)
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
