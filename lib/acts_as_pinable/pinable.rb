module ActsAsPinable
  module Pinable
    extend ActiveSupport::Concern

    included do
      scope :sticky, -> { where(sticky: true) }
    end

    def pinable?
      true
    end

    def pined
      clear_sticky
      update(sticky: true)
    end

    def unpined
      update(sticky: false)
    end

    private

    def clear_sticky
      group.posts.sticky.update(sticky: false)
    end
  end
end
