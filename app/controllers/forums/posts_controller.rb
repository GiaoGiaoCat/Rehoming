class Forums::PostsController < ApplicationController
  serialization_scope :current_forum

  def index
    load_posts
    render json: @posts, include: '**'
  end

  def create
    build_post
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors.messages, status: :bad_request
    end
  end

  private

  def current_forum
    @forum ||= Forum.find(params[:forum_id])
  end

  def load_posts
    @posts = current_forum.posts.by_filter(params[:filter]).by_user(current_user, current_forum)
  end

  def build_post
    @post = current_forum.posts.new
    @post.attributes = post_params.merge(user_id: current_user.id)
  end

  def post_params
    attrs = [:content, attachments_attributes: %i(category url)]
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: attrs)
  end
end
