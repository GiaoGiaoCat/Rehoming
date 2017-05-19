class Posts::RecommendationsController < ApplicationController
  before_action :load_parent

  def create
    @current_user.recommend(@parent)
    head :created
  end

  def destroy
    @current_user.unrecommend(@parent)
    head :no_content
  end
end
