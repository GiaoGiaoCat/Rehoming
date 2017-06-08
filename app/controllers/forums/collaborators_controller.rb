class Forums::CollaboratorsController < ApplicationController
  before_action :load_forum

  def create
    build_collaborator
    @collaborator.save
    head :created
  end

  def destroy
    build_reduce_collaborator
    authorize @forum, :manage_collaborator?
    @reduce_collaborator.save
    head :no_content
  end

  private

  def load_forum
    @forum ||= Forum.find(params[:forum_id])
  end

  def build_collaborator
    @collaborator = Roles::BecomeCollaboratorService.new(user: current_user)
    @collaborator.attributes = collaborator_params
  end

  def build_reduce_collaborator
    user = @forum.members.find(params[:id])
    @reduce_collaborator = Roles::ReduceService.new(forum: @forum, user: user, role: :collaborator)
  end

  def collaborator_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :invitation_token)
  end
end
