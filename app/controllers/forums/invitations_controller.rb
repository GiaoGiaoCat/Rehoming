class Forums::InvitationsController < ApplicationController
  def create
    load_forum
    build_invitation
    if @invitation.save
      head :created
    else
      render json: @invitation.errors.messages, status: :bad_request
    end
  end

  private

  def load_forum
    @forum = Forum.find(params[:forum_id])
  end

  def build_invitation
    @invitation = Forums::Invitation.new(forum: @forum)
    authorize @invitation
  end
end
