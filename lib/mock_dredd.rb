module MockDredd
  extend ActiveSupport::Concern

  included do
    if Rails.env.development?
      before_action :hack_create_session_dev
      before_action :hack_update_feed_dev
      before_action :load_forum_dev
      before_action :hack_show_post_preview_dev
      before_action :load_post_dev
      before_action :load_post_for_comment_dev
      before_action :load_favorites_dev
      before_action :load_comment_dev
      before_action :hack_destroy_member_dev
    end
  end

  private

  def hack_create_session_dev
    return unless controller_name == 'sessions'
    return unless action_name == 'create'
    load_development_user
    @session = Users::Session.create(user: @current_user)
    render json: @session, status: :created
  end

  def hack_update_feed_dev
    return unless controller_name == 'feeds'
    return unless action_name == 'update'
    cache_key = current_user.feeds.value.first
    fetch = Feeds::FetchService.new(key: cache_key)
    @feed = fetch.save ? fetch.object : nil
    @feed.make_as_read!
    render json: @feed
  end

  def load_forum_dev
    ary = ['forums/posts', 'forums/post_previews', 'forums/members']
    return unless ary.include? controller_path
    @forum = Forum.first
  end

  def hack_show_post_preview_dev
    return unless controller_name == 'post_previews'
    return unless action_name == 'show'
    render json: Post.first, serializer: Forums::PostPreviewSerializer, include: '**'
  end

  def load_post_dev
    ary = ['posts/likes', 'posts/pins', 'posts/favorites', 'posts/recommendations']
    return unless ary.include? controller_path
    @parent = Post.first
  end

  def load_post_for_comment_dev
    ary = ['posts/comments']
    return unless ary.include? controller_path
    @parent = Post.last
  end

  def load_comment_dev
    ary = ['comments/likes']
    return unless ary.include? controller_path
    @parent = Comment.first
  end

  def load_favorites_dev
    return unless controller_name == 'favorites'
    return unless action_name == 'index'
    current_user.favor(Post.first)
  end

  def hack_destroy_member_dev
    return unless controller_path == 'forums/members'
    return unless action_name == 'destroy'
    return head :no_content
  end
end
