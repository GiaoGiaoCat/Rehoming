class Groups::PostsController < ApplicationController
  before_action :load_group

  def index
    load_posts
    render json: @posts, include: [:author, comments: %i(author attachments comments)]
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

  def load_group
    @group = Group.find(params[:group_id])
  end

  def load_posts
    @posts = @group.posts
  end

  def build_post
    @post = @group.posts.new
    @post.attributes = post_params.merge(user_id: current_user.id)
  end

  def post_params
    attrs = [:content, attachments_attributes: %i(category url)]
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: attrs)
  end
end
