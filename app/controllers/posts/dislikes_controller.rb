class Posts::DislikesController < ApplicationController
  include LikeableResources
  likeable_resources action: :dislike
end
