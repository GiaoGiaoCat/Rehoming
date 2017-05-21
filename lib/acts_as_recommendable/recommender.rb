module ActsAsRecommendable
  module Recommender
    extend ActiveSupport::Concern

    def recommend(obj)
      return unless obj.respond_to? :recommendable?
      obj.starred
    end

    def unrecommend(obj)
      return unless obj.respond_to? :recommendable?
      obj.unstarred
    end
  end
end
