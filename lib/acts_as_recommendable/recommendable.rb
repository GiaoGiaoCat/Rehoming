module ActsAsRecommendable
  module Recommendable
    extend ActiveSupport::Concern

    included do
      scope :recommended, -> { where(recommended: true) }
    end

    def recommendable?
      true
    end

    def stared
      return true if recommended?
      update(recommended: true)
    end

    def unstared
      return true unless recommended?
      update(recommended: false)
    end
  end
end
