module ActsAsLikeable
  module Likeable
    extend ActiveSupport::Concern

    included do
      has_many :likes, as: :likeable, dependent: :destroy
    end

    def likeable?
      true
    end

    # Get the times this item was favored
    def times_liked
      likes.count
    end
  end
end
