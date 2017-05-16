class PostsController < ApplicationController
  serialization_scope :group

  def show
    load_post
    render json: @post, include: [:author, comments: %i(author attachments comments)]
  end

  private

  def load_post
    @post = Post.find(params[:id])
  end

  def group
    @post.group
  end
end
