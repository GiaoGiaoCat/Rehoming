module FavorableResources
  extend ActiveSupport::Concern

  module ClassMethods
    def favorable_resources(options = {})
      cattr_accessor :action
      self.action = options[:action].to_sym || :favor
    end
  end

  def create
    create_able_resource
  end

  private

  def verb_name
    :favor
  end

  def unverb_name
    :unfavor
  end

  def build_operation_obj
    @operation_obj =
      case self.class.action
      when verb_name
        current_user.favorites.build(favorable: @parent)
      when unverb_name
        current_user.favorites.where(favorable: @parent)
      end
  end
end
