class Forums::PostsController < ApplicationController
  serialization_scope :current_forum

  def index
    load_posts
    render json: @posts, include: '**'
  end

  def create
    build_post
    if @post.save
      render json: @post.becomes(Post), status: :created
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
    @post = Posts::Form.new(forum: current_forum, user_id: current_user.id)
    @post.attributes = post_params
  end

  def post_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i(content attachments_attributes))
  end
end
