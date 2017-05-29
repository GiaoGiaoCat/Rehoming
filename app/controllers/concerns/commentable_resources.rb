module CommentableResources
  extend ActiveSupport::Concern

  def create
    load_parent
    build_comment
    if @comment.save
      head :created
    else
      render json: @comment.errors.messages, status: :bad_request
    end
  end

  private

  def build_comment
    @comment = Comments::Form.new(commentable: @parent, author: current_user)
    @comment.attributes = comment_params
  end

  def comment_params
    params.require(:data).permit(attributes: [:content, :replied_user_id, attachments_attributes: %i(category url)])
  end
end
