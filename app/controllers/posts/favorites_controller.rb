class Posts::FavoritesController < ApplicationController
  include FavorableResources
  favorable_resources action: :favor
end
