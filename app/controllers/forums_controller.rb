class ForumsController < ApplicationController
  def show
    @forum = Forum.find(params[:id])
    render json: @forum, include: '**'
  end

  def create
    build_forum
    if @forum_form.save
      head :created
    else
      puts @forum_form.errors.inspect

      render json: @forum_form.errors.messages, status: :bad_request
    end
  end

  private

  def build_forum
    @forum_form = Forums::Form.new(user: current_user)
    @forum_form.attributes = forum_form_params
  end

  def forum_form_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i[name description cover category background_color])
  end
end
