class Comments::DislikesController < ApplicationController
  include LikeableResources
  likeable_resources action: :dislike
end
