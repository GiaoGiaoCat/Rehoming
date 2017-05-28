class Forums::MembershipRequestsController < ApplicationController
  serialization_scope :current_forum

  def index
    load_membership_requests
    render json: @membership_requests, include: %i(user forum), each_serializer: Forums::MembershipRequestSerializer
  end

  def create
    @current_user.join_forum(current_forum)
    head :no_content
  end

  def update
    build_membership_request
    if @membership_request.update_status
      head :no_content
    else
      render json: @membership_request.errors.messages, status: :bad_request
    end
  end

  private

  def current_forum
    @forum ||= Forum.find(params[:forum_id])
  end

  def load_membership_requests
    @membership_requests = current_forum.membership_requests
  end

  def build_membership_request
    @membership_request = current_forum.membership_requests.find_by_encrypted_id(params[:id])
    @membership_request.attributes = membership_request_params
  end

  def membership_request_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :action)
  end
end
