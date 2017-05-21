class Posts::FavoritesController < ApplicationController
  include ActsAsAction
  define_action_names verb: :favor, unverb: :unfavor
end
