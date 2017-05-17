module ActsAsPinable
  module Pinable
    extend ActiveSupport::Concern

    def likeable?
      true
    end

    def pin
      clear_sticky
      update(sticky: true)
    end

    def unpin
      update(sticky: false)
    end

    private

    def clear_sticky
      group.posts.where(sticky: true).update(sticky: false)
    end
  end
end
