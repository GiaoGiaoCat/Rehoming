module ActsAsPinable
  module Piner
    extend ActiveSupport::Concern

    def pin(obj)
      return unless obj.respond_to? :pinable?
      obj.pined
    end

    def unpin(obj)
      return unless obj.respond_to? :pinable?
      obj.unpined
    end
  end
end
