class Groups::PostsController < ApplicationController
  serialization_scope :group

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

  def group
    @group = Group.find(params[:group_id])
  end

  def load_posts
    @posts = group.posts.by_filter(params[:filter])
  end

  def build_post
    @post = group.posts.new
    @post.attributes = post_params.merge(user_id: current_user.id)
  end

  def post_params
    attrs = [:content, attachments_attributes: %i(category url)]
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: attrs)
  end
end
