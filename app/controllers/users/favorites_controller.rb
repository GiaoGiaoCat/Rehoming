class Users::FavoritesController < ApplicationController
  def index
    load_favorites
    render json: @favorites, include: %i(forum attachments)
  end

  private

  def load_favorites
    @favorites = current_user.favorite_posts
  end
end
