class Posts::PinsController < ApplicationController
  before_action :load_parent

  def create
    @current_user.pin(@parent)
    head :created
  end

  def destroy
    @current_user.unpin(@parent)
    head :no_content
  end
end
