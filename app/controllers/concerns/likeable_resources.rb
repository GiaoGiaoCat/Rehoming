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
    resource, id = request.path.split('/')[1, 2]
    @likeable = resource.singularize.classify.constantize.find(id)
  end

  def build_operation_obj
    @like = current_user.likes.build(likeable: @likeable)
  end

  def execute_operation
    @like.save
  end
end
