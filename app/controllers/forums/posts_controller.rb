class Forums::PostsController < ApplicationController
  serialization_scope :view_variables

  def index
    load_posts
    render json: @posts, include: '**'
  end

  def create
    build_form
    if @post_form.save
      instrument 'created.post', sourceable: @post_form.object, handler: current_user
      render json: @post_form.object.becomes(Post), status: :created
    else
      render json: @post_form.errors.messages, status: :bad_request
    end
  end

  private

  def current_forum
    @forum ||= Forum.find(params[:forum_id])
  end

  def load_posts
    @posts = current_forum.posts.by_filter(params[:filter]).by_user(current_user, current_forum)
  end

  def build_form
    @post_form = Posts::CreateForm.new(forum: current_forum, author: current_user)
    @post_form.attributes = post_params
  end

  def post_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i(content attachments_attributes))
  end

  def view_variables
    { current_forum: current_forum, current_user: current_user }
  end
end
