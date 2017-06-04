class Forums::MembersController < ApplicationController
  serialization_scope :view_variables

  def index
    load_members
    render json: @members, each_serializer: Forums::MemberSerializer
  end

  def destroy
    load_member
    authorize @forum, :destroy_member?
    @member.quit_forum(@forum)
    head :no_content
  end

  private

  def current_forum
    @forum ||= Forum.find(params[:forum_id])
  end

  def load_members
    @members = current_forum.visible_members
  end

  def load_member
    @member = current_forum.visible_members.find(params[:id])
  end

  def view_variables
    { current_forum: current_forum, current_user: current_user }
  end
end
