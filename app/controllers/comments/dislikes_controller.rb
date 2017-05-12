class Comments::DislikesController < ApplicationController
  include LikeableResources

  private

  def build_operation_obj
    @dislike = current_user.likes.where(likeable: @likeable)
  end

  def execute_operation
    @dislike.destroy_all
  end
end
