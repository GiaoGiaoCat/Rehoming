class Groups::JoinsController < ApplicationController
  include RestfulResources
  restful_resources resource_name: :group_join

  private

  def resource_scope
    Groups::Join
  end

  def resource_params
    params.permit(:group_id).merge(user_id: current_user.id)
  end
end
