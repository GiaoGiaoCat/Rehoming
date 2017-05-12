class Posts::LikesController < ApplicationController
  include LikeableResources
  likeable_resources action: :like
end
