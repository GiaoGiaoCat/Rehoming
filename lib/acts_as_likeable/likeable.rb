module ActsAsLikeable
  module Likeable
    extend ActiveSupport::Concern

    included do
      has_many :likes, as: :likeable
    end

    def likeable?
      true
    end
  end
end
