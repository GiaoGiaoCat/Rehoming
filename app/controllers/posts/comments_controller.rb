class Posts::CommentsController < ApplicationController
  before_action :load_parent

  def create
    build_comment
    if @comment_form.save
      instrument 'commented.post', sourceable: @parent, handler: current_user
      instrument 'replied.comment', sourceable: @comment_form.object, handler: current_user
      head :created
    else
      render json: @comment_form.errors.messages, status: :bad_request
    end
  end

  private

  def build_comment
    @comment_form = Comments::CreateForm.new(commentable: @parent, author: current_user)
    @comment_form.attributes = comment_params.merge(decrypted_replied_user_id)
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
