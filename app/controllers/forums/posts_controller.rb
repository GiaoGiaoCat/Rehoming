class Forums::PostsController < ApplicationController
  serialization_scope :view_variables

  def index
    load_posts
    render json: @posts, include: '**'
  end

  def create
    build_post
    if @post.save
      instrument 'created.post', sourceable: @post, handler: current_user
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
    @post = Posts::CreateService.new(forum: current_forum, author: current_user)
    @post.attributes = post_params
  end

  def post_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i(content attachments_attributes))
  end

  def view_variables
    { current_forum: current_forum, current_user: current_user }
  end
end
