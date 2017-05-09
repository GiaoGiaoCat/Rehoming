class Groups::JoinsController < ApplicationController
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
    @group_join.attributes = group_join_params.merge(user_id: current_user.id)
  end

  def group_join_params
    params.permit(:group_id)
  end
end
