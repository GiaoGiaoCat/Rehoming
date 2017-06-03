class Forums::AdminsController < ApplicationController
  before_action :load_forum, :load_member, :build_form_member_as_admin

  def create
    if @as_admin.save
      head :created
    else
      render json: @as_admin.errors.messages, status: :bad_request
    end
  end

  def destroy
    if @as_admin.destroy
      head :no_content
    else
      render json: @as_admin.errors.messages, status: :bad_request
    end
  end

  private

  def load_forum
    @forum = Forum.find(params[:forum_id])
  end

  def load_member
    @member = @forum.members.find(params[:member_id])
  end

  def build_form_member_as_admin
    @as_admin = Forums::Members::AsAdmin.new(forum: @forum, user: @member)
    authorize @as_admin
  end
end
