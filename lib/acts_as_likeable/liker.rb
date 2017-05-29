module ActsAsLikeable
  module Liker
    extend ActiveSupport::Concern

    included do
      has_many :likes
    end

    def liked?(obj)
      find_likes(obj).any?
    end

    def like(obj)
      return unless obj.respond_to? :likeable?
      return if liked?(obj)
      # find_likes(obj).create
      Likes::Form.create(liker: self, likeable: obj)
    end

    def dislike(obj)
      return unless obj.respond_to? :likeable?
      find_likes(obj).delete_all
    end

    def find_likes(likeable)
      # likes.where(extra_conditions)
      likes.where(likeable: likeable)
    end
  end
end
