module CommentableResources
  extend ActiveSupport::Concern

  def create
    load_commentable
    build_comment
    if @comment.save
      head :created
    else
      render json: @comment.errors.messages, status: :bad_request
    end
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def build_comment
    @comment = Comment.new(commentable: @commentable, user: current_user)
    @comment.attributes = comment_params
  end

  def comment_params
    # params.permit(:content, :image_url)
    # params.require(:data).permit(attributes: [:content, attachments_attributes: %i(category url)])
    params.require(:data).permit(attributes: %i(content image_url))
  end
end
