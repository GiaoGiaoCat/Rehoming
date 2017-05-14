class Posts::UnfavoritesController < ApplicationController
  include FavorableResources
  favorable_resources action: :unfavor
end
