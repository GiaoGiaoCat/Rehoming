module LikeableResources
  extend ActiveSupport::Concern

  module ClassMethods
    def likeable_resources(options = {})
      cattr_accessor :action
      self.action = options[:action].to_sym || :like
    end
  end

  def create
    create_able_resource
  end

  private

  def verb_name
    :like
  end

  def unverb_name
    :dislike
  end

  def build_operation_obj
    @operation_obj =
      case self.class.action
      when verb_name
        current_user.likes.build(likeable: @parent)
      when unverb_name
        current_user.likes.where(likeable: @parent)
      end
  end
end
