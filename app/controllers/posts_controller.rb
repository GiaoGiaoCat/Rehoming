class PostsController < ApplicationController
  serialization_scope :view_variables

  before_action :load_post

  def show
    render json: @post, include: '**'
  end

  private

  def load_post
    @post = Post.find(params[:id])
  end

  def view_variables
    { current_forum: @post.forum, current_user: current_user }
  end
end
