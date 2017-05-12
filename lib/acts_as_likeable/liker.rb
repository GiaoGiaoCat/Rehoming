module ActsAsLikeable
  module Liker
    extend ActiveSupport::Concern

    included do
      has_many :likes
    end

    def liked?(obj)
      find_likes(obj).empty?
    end

    def like(obj)
      return unless obj.respond_to? :likeable?
      find_likes(obj).create
    end

    def dislike(obj)
      return unless obj.respond_to? :likeable?
      find_likes(obj).destroy_all
    end

    def find_likes(likeable)
      # likes.where(extra_conditions)
      likes.where(likeable: likeable)
    end
  end
end
