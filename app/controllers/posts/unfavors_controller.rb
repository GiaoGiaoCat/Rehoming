class Posts::UnfavorsController < ApplicationController
  include FavorableResources
  favorable_resources action: :unfavor
end
