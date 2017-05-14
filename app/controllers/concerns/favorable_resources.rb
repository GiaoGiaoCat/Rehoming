module FavorableResources
  extend ActiveSupport::Concern

  module ClassMethods
    def favorable_resources(options = {})
      cattr_accessor :action, :resource_name
      self.action = options[:action].to_sym || :fave
      self.resource_name = 'favorites'
    end
  end

  def create
    create_able_resource
  end

  private

  def verb_name
    :fave
  end

  def unverb_name
    :unfave
  end
end
