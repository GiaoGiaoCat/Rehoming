class Forums::BlockedMembersController < ApplicationController
  def index
    load_forum
    authorize @forum, :view_blocked_members?
    load_blocked_members
    render json: @blocked_members, each_serializer: Forums::MemberSerializer
  end

  def create
    load_forum
    authorize @forum, :create_blocked_member?
    build_blocked_member
    @blocked_member.save
    head :no_content
  end

  def destroy
    load_forum
    authorize @forum, :destroy_blocked_member?
    build_blocked_member
    @blocked_member.destroy
    head :no_content
  end

  private

  def load_forum
    @forum ||= Forum.find(params[:forum_id])
  end

  def load_blocked_members
    @blocked_members = @forum.blocked_members
  end

  def build_blocked_member
    @blocked_member = Forums::BlockedMembership.new(forum: @forum)
    @blocked_member.attributes = blocked_member_params
  end

  def blocked_member_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :user_id)
  end
end
