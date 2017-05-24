class ForumsController < ApplicationController
  def show
    @forum = Forum.find(params[:id])
    render json: @forum, include: '**'
  end
end
