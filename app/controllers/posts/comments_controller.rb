class Posts::CommentsController < ApplicationController
  before_action :load_parent

  def create
    build_comment
    if @comment.save
      instrument 'commented.post', obj_id: @parent.id, handler_id: current_user.id
      instrument 'replied.comment', obj_id: @comment.id, handler_id: current_user.id
      head :created
    else
      render json: @comment.errors.messages, status: :bad_request
    end
  end

  private

  def build_comment
    @comment = @parent.comments.new(author: current_user)
    @comment.attributes = comment_params.merge(decrypted_replied_user_id)
  end

  def comment_params
    attrs = %i(content replied_user_id attachments_attributes)
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: attrs)
  end

  def decrypted_replied_user_id
    return {} unless comment_params[:replied_user_id]
    { replied_user_id: User.decrypt(User.encrypted_id_key, comment_params[:replied_user_id]) }
  end
end
