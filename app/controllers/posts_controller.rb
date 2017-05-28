class PostsController < ApplicationController
  serialization_scope :current_forum

  def show
    load_post
    render json: @post, include: '**'
  end

  private

  def load_post
    @post = Post.find(params[:id])
  end

  def current_forum
    @post.forum
  end
end
