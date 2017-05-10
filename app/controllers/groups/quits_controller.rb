class Groups::QuitsController < ApplicationController
  include RestfulResources
  restful_resources resource_name: :group_quit

  private

  def resource_scope
    Groups::Quit
  end

  def resource_params
    params.permit(:group_id).merge(user_id: current_user.id)
  end
end
