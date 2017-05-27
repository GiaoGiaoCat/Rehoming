class Forums::BlockedMembersController < ApplicationController
  def create
    build_blocked_member
    @blocked_member.save
    head :no_content
  end

  def destroy
    build_blocked_member
    @blocked_member.destroy
    head :no_content
  end

  private

  def forum
    @forum = Forum.find(params[:forum_id])
  end

  def build_blocked_member
    @blocked_member = Forums::BlockedMembership.new(forum: forum)
    @blocked_member.attributes = blocked_member_params
  end

  def blocked_member_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :user_id)
  end
end
