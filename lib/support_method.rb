module SupportMethod
  extend ActiveSupport::Concern

  private

  def load_parent
    resource, id = request.path.split('/')[1, 2]
    @parent = resource.singularize.classify.constantize.find(id)
  end
  
  def pagination_number
    params[:page].blank? ? 1 : params[:page][:number]
  end
end
