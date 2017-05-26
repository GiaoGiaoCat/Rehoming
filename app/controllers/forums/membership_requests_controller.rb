class Forums::MembershipRequestsController < ApplicationController
  serialization_scope :forum

  def index
    load_membership_requests
    render json: @membership_requests, include: %i(user forum), each_serializer: Forums::MembershipRequestSerializer
  end

  def update
    build_membership_requests
    if @membership_request.save
      head :no_content
    else
      render json: @membership_request.errors.messages, status: :bad_request
    end
  end

  private

  def forum
    @forum = Forum.find(params[:forum_id])
  end

  def load_membership_requests
    @membership_requests = forum.membership_requests
  end

  def build_membership_request
    @membership_request = forum.membership_requests
    @membership_request.attributes = membership_request_params
  end

  def membership_request_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :action)
  end
end
