class Forums::AdminsController < ApplicationController
  def create
    load_forum
    load_member
    build_form_member_as_admin

    if @as_admin.save
      head :created
    else
      render json: @as_admin.errors.messages, status: :bad_request
    end
  end

  def destroy
    load_forum
    load_member
    build_form_member_as_admin

    if @as_admin.destroy
      head :created
    else
      render json: @as_admin.errors.messages, status: :bad_request
    end
  end

  private

  def load_forum
    @forum = Forum.find(params[:forum_id])
    authorize @forum
  end

  def load_member
    @member = @forum.members.find(params[:member_id])
  end

  def build_form_member_as_admin
    @as_admin = Forums::Members::AsAdmin.new(forum: @forum, user: @member)
  end
end
