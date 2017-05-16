class Posts::FavorsController < ApplicationController
  include FavorableResources
  favorable_resources action: :favor
end
