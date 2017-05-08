class Groups::JoinsController < ApplicationController
  # before_action :authenticate_request!

  def create
    build_group_join
    if @group_join.save
      render json: @group_join
    else
      render json: @group_join.errors.full_messages, status: :bad_request
    end
  end

  private

  def build_group_join
    @group_join = Groups::Join.new
    # @group_join.attributes = group_join_params.merge(user_id: current_user.id)
    @group_join.attributes = group_join_params
  end

  def group_join_params
    # params.permit(:group_id)
    params.permit(:group_id, :user_id)
  end
end
