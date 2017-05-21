module ActsAsPinable
  module Pinable
    extend ActiveSupport::Concern

    included do
      default_scope -> { order(sticky: :desc) }
      scope :sticky, -> { where(sticky: true) }
    end

    def pinable?
      true
    end

    def pined
      return true if sticky?
      clear_sticky
      update(sticky: true)
    end

    def unpined
      return true unless sticky?
      update(sticky: false)
    end

    private

    def clear_sticky
      forum.posts.sticky.update(sticky: false)
    end
  end
end
