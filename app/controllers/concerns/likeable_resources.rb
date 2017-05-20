module LikeableResources
  extend ActiveSupport::Concern

  included do
    before_action :load_parent
  end

  def create
    @current_user.like @parent
    head :created
  end

  def destroy
    @current_user.dislike @parent
    head :no_content
  end
end
