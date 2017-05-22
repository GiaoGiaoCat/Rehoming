module ActsAsPinable
  module Piner
    extend ActiveSupport::Concern

    def pin(obj)
      validate_beable_resource(obj, :pinable?)
      obj.pinned
    end

    def unpin(obj)
      validate_beable_resource(obj, :pinable?)
      obj.unpinned
    end

    private

    def validate_beable_resource(obj, method)
      return unless obj.respond_to? method
    end
  end
end
