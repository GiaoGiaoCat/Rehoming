class Groups::RenamesController < ApplicationController
  def create
    build_rename
    if @rename.save
      render json: @rename
    else
      render json: @rename.errors.full_messages, status: :bad_request
    end
  end

  private

  def build_rename
    @rename = Groups::Rename.new
    @rename.attributes = params.permit(:group_id, :name).merge(user: current_user)
  end
end
