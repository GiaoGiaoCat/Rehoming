class PostsController < ApplicationController
  def create
    build_post
    if @post.save
      render json: @post, status: :created, serializer: PostSerializer
    else
      render json: @post.errors.messages, status: :bad_request
    end
  end

  private

  def build_post
    @post = Post.new
    @post.attributes = post_params.merge(user_id: current_user.id)
  end

  def post_params
    params.require(:data).permit(attributes: [:group_id, :content, attachments_attributes: %i(category url)])
  end
end
