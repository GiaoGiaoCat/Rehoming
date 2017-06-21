class Users::PostsController < ApplicationController
  def index
    load_posts
    options = { each_serializer: Users::PostSerializer, include: %i(forum attachments) }
    render json: explicit_serializer(@posts, options).as_json
  end

  private

  def load_posts
    @posts = current_user.posts.page(pagination_number)
  end
end
