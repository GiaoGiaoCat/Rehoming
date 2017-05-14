module ActsAsFavable
  module Favable
    extend ActiveSupport::Concern

    included do
      has_many :favorites, as: :favable, dependent: :destroy
    end

    def favorable?
      true
    end

    # Get the times this item was favored
    def times_favored
      favorites.count
    end
  end
end
