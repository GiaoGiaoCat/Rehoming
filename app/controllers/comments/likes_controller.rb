class Comments::LikesController < ApplicationController
  include LikeableResources

  private

  def build_operation_obj
    @like = current_user.likes.build(likeable: @likeable)
  end

  def execute_operation
    @like.save
  end
end
