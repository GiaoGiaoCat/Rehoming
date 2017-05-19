module ActsAsRecommendable
  module Recommender
    extend ActiveSupport::Concern

    def recommend(obj)
      return unless obj.respond_to? :recommendable?
      obj.stared
    end

    def unrecommend(obj)
      return unless obj.respond_to? :recommendable?
      obj.unstared
    end
  end
end
