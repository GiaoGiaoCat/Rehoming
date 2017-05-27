class Forums::MembersController < ApplicationController
  serialization_scope :forum

  def index
    load_members
    render json: @members, each_serializer: Forums::MemberSerializer
  end

  private

  def forum
    @forum = Forum.find(params[:forum_id])
  end

  def load_members
    @members = forum.members.by_filter(params[:filter])
  end
end
