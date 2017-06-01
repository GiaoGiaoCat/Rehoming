class PostsController < ApplicationController
  serialization_scope :view_variables

  def show
    load_post
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
