class Forums::QuitsController < ApplicationController
  include RestfulResources
  restful_resources resource_name: :forum_quit

  private

  def resource_scope
    Forums::Quit
  end

  def resource_params
    params.permit(:forum_id).merge(user_id: current_user.id)
  end
end
