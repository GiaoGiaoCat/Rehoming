class Posts::RecommendationsController < ApplicationController
  before_action :load_parent

  def create
    authorize @parent.forum, :manage_recommend?
    @current_user.recommend(@parent)
    head :created
  end

  def destroy
    authorize @parent.forum, :manage_recommend?
    @current_user.unrecommend(@parent)
    head :no_content
  end
end
