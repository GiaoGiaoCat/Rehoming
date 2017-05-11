class CommentsController < ApplicationController
  before_action :authenticate_request!

  def create
    build_comment
    if @comment.save
      head :created
    else
      render json: @comment.errors.messages, status: :bad_request
    end
  end

  private

  def build_comment
    @comment = Comments::Form.new
    @comment.attributes = comment_params.merge(user: current_user)
  end

  def comment_params
    params.permit(:post_id, :comment_id, :content, :image_url)
  end
end
