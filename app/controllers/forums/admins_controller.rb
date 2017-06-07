class Forums::AdminsController < ApplicationController
  before_action :load_forum, :load_member

  def create
    build_admin
    @admin.save
    head :created
  end

  def destroy
    build_reduce_admin
    @reduce_admin.save
    head :no_content
  end

  private

  def load_forum
    @forum = Forum.find(params[:forum_id])
  end

  def load_member
    @member = @forum.members.find(params[:id])
  end

  def build_admin
    @admin = Roles::BecomeAdminService.new(forum: @forum, user: @member)
  end

  def build_reduce_admin
    @reduce_admin = Roles::ReduceService.new(forum: @forum, user: @member, role: :admin)
  end
end
