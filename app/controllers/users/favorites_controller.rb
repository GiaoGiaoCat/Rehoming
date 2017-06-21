class Users::FavoritesController < ApplicationController
  def index
    load_favorites
    options = { each_serializer: Users::PostSerializer, include: %i(forum attachments) }
    render json: explicit_serializer(@favorites, options).as_json
  end

  private

  def load_favorites
    @favorites = current_user.favorite_posts.page(pagination_number)
  end
end
