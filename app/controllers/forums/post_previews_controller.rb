class Forums::PostPreviewsController < ApplicationController
  skip_before_action :authenticate_request!
  serialization_scope :view_variables

  def index
    load_posts
    options = { each_serializer: Forums::PostPreviewSerializer, include: '**' }
    render json: explicit_serializer(@posts, options).as_json
  end

  def show
    load_post
    options = { serializer: Forums::PostPreviewSerializer, include: '**' }
    render json: explicit_serializer(@post, options).as_json
  end

  private

  def current_forum
    @forum ||= Forum.find(params[:forum_id])
  end

  def load_posts
    @posts = current_forum.posts.limit(10)
  end

  def load_post
    @post = current_forum.posts.find(params[:id])
  end

  def view_variables
    { current_forum: current_forum }
  end
end
