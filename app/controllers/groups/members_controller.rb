class Groups::MembersController < ApplicationController
  serialization_scope :group

  def index
    load_members
    render json: @members
  end

  private

  def group
    @group = Group.find(params[:group_id])
  end

  def load_members
    @members = group.users
  end
end
