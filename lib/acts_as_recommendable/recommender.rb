module ActsAsRecommendable
  module Recommender
    extend ActiveSupport::Concern

    def recommend(obj)
      validate_beable_resource(obj, :recommendable?)
      obj.starred
    end

    def unrecommend(obj)
      validate_beable_resource(obj, :recommendable?)
      obj.unstarred
    end

    private

    def validate_beable_resource(obj, method)
      return unless obj.respond_to? method
    end
  end
end
