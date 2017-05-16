class Groups::PostsController < ApplicationController
  def index
    load_group
    load_posts
    render json: @posts, include: [comments: %i(attachments comments)]
  end

  private

  def load_group
    @group = Group.find(params[:group_id])
  end

  def load_posts
    @posts = @group.posts
  end
end
