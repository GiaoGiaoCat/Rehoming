class Forums::CollaboratorsController < ApplicationController
  before_action :load_forum

  def create
    build_collaborator
    @collaborator.save
    head :created
  end

  private

  def load_forum
    @forum ||= Forum.find(params[:forum_id])
  end

  def build_collaborator
    @collaborator = Memberships::BecomeCollaboratorService.new(user: current_user)
    @collaborator.attributes = collaborator_params
  end

  def collaborator_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :invitation_token)
  end
end
