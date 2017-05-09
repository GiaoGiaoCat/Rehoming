class Groups::QuitsController < ApplicationController
  before_action :authenticate_request!

  def create
    build_group_quit
    if @group_quit.save
      render json: @group_quit
    else
      render json: @group_quit.errors.full_messages, status: :bad_request
    end
  end

  private

  def build_group_quit
    @group_quit = Groups::Quit.new
    @group_quit.attributes = group_quit_params.merge(user_id: current_user.id)
  end

  def group_quit_params
    params.permit(:group_id)
  end
end
