class Posts::DislikesController < ApplicationController
  include LikeableResources

  private

  def build_operation_obj
    @dislike = current_user.likes.where(likeable: @post)
  end

  def execute_operation
    @dislike.destroy_all
  end
end
