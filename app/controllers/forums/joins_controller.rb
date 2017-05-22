class Forums::JoinsController < ApplicationController
  include RestfulResources
  restful_resources resource_name: :forum_join

  private

  def resource_scope
    Forums::Join
  end

  def resource_params
    params.permit(:forum_id).merge(user_id: current_user.id)
  end
end
