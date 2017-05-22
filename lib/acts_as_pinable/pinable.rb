module ActsAsPinable
  module Pinable
    extend ActiveSupport::Concern

    included do
      default_scope -> { order(sticky: :desc) }
      scope :by_pinned, -> { where(sticky: true) }
    end

    def pinable?
      true
    end

    def pinned
      return if sticky?
      clear_pinned
      update(sticky: true)
    end

    def unpinned
      return unless sticky?
      update(sticky: false)
    end

    private

    def clear_pinned
      forum.posts.by_pinned.update(sticky: false)
    end
  end
end
