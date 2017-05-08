class Groups::MembersController < ApplicationController
  def index
    load_group
    load_members
    render json: @members
  end

  private

  def load_group
    @group = Group.find(params[:group_id])
  end

  def load_members
    @members = @group.users
  end
end
