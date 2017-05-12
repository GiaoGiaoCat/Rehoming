module LikeableResources
  extend ActiveSupport::Concern

  def create
    load_likeable
    build_operation_obj
    execute_operation
    head :created
  end

  private

  def load_likeable
    @post = Post.find(params[:post_id])
  end

  def build_operation_obj
    @like = current_user.likes.build(likeable: @post)
  end

  def execute_operation
    @like.save
  end
end
