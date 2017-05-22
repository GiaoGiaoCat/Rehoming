class Forums::RenamesController < ApplicationController
  def create
    load_forum
    build_rename
    if @rename.save
      head :created
    else
      render json: @rename.errors.full_messages, status: :bad_request
    end
  end

  private

  def load_forum
    @forum = Forum.find(params[:forum_id])
  end

  def build_rename
    @rename = Forums::Rename.new
    @rename.attributes = rename_params.merge(user: current_user, forum: @forum)
  end

  def rename_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :name)
  end
end
