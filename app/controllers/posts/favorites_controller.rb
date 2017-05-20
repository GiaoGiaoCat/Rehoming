class Posts::FavoritesController < ApplicationController
  before_action :load_parent

  def create
    @current_user.favor(@parent)
    head :created
  end

  def destroy
    @current_user.unfavor(@parent)
    head :no_content
  end
end
