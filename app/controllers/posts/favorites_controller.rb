class Posts::FavoritesController < ApplicationController
  include ActsAsActionStore
  define_action_names verb_name: :favor
end
