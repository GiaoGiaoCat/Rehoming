class Groups::RenamesController < ApplicationController
  def create
    load_group
    build_rename
    if @rename.save
      head :created
    else
      render json: @rename.errors.full_messages, status: :bad_request
    end
  end

  private

  def load_group
    @group = Group.find(params[:group_id])
  end

  def build_rename
    @rename = Groups::Rename.new
    @rename.attributes = rename_params.merge(user: current_user, group: @group)
  end

  def rename_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :name)
  end
end
