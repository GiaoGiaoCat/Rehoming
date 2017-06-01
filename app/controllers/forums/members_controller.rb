class Forums::MembersController < ApplicationController
  serialization_scope :view_variables

  def index
    load_members
    render json: @members, each_serializer: Forums::MemberSerializer
  end

  private

  def current_forum
    @forum ||= Forum.find(params[:forum_id])
  end

  def load_members
    @members = current_forum.visible_members.by_filter(params[:filter])
  end

  def view_variables
    { current_forum: current_forum, current_user: current_user }
  end
end
