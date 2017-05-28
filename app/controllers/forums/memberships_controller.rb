class Forums::MembershipsController < ApplicationController
  def destroy
    @current_user.quit_forum(forum)
    head :no_content
  end

  private

  def forum
    @forum = Forum.find(params[:forum_id])
  end
end
