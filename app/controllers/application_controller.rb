class ApplicationController < ActionController::API
  private

  def get_resource_status(obj, *attrs)
    attrs.each do |attr|
      error = obj.errors.details.fetch(attr, nil)
      return error[0][:status] || :bad_request if error
    end
  end

  def render_error_msg(obj, *attrs)
    status = get_resource_status(obj, *attrs)
    render json: obj, status: status, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
  end
end
