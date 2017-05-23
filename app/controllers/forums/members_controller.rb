class Forums::MembersController < ApplicationController
  serialization_scope :forum

  def index
    load_members
    render json: @members
  end

  private

  def forum
    @forum = Forum.find(params[:forum_id])
  end

  def load_members
    @members = forum.members
  end
end
