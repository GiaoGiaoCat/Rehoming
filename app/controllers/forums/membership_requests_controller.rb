class Forums::MembershipRequestsController < ApplicationController
  serialization_scope :view_variables

  def index
    load_membership_requests
    render json: @membership_requests,
           include: %i(user forum),
           each_serializer: Forums::MembershipRequestSerializer
  end

  def create
    build_membership_request
    if @membership_request.save
      head :created
    else
      render json: @membership_request.errors.messages, status: :bad_request
    end
  end

  def update
    load_membership_request
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
    authorize @forum, :view_membership_requests?
  end

  def load_membership_request
    @membership_request = current_forum.membership_requests.find(params[:id])
    authorize @membership_request.becomes(Forums::MembershipRequest)
  end

  def build_membership_request
    @membership_request ||= Forums::MembershipRequest.new(forum: current_forum, user: current_user)
    @membership_request.attributes = membership_request_params
  end

  def membership_request_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :action)
  end

  def view_variables
    { current_forum: current_forum, current_user: current_user }
  end
end
