module MockDredd
  extend ActiveSupport::Concern

  included do
    if Rails.env.development?
      before_action :load_session_dev
      before_action :load_feed_dev
      before_action :load_forum_dev
      before_action :load_post_preview_dev
      before_action :load_post_dev
    end
  end

  private

  def load_session_dev
    if controller_name == 'sessions' && action_name == 'create'
      load_development_user
      @session = Users::Session.create(user: @current_user)
      render json: @session, status: :created
    end
  end

  def load_feed_dev
    if controller_name == 'feeds' && action_name == 'update'
      cache_key = current_user.feeds.value.first
      fetch = Feeds::FetchService.new(key: cache_key)
      @feed = fetch.save ? fetch.object : nil
      @feed.make_as_read!
      render json: @feed
    end
  end

  def load_forum_dev
    @forum = Forum.first if %w[post_previews members].include? controller_name
  end

  def load_post_preview_dev
    if controller_name == 'post_previews' && action_name == 'show'
      render json: Post.first, serializer: Forums::PostPreviewSerializer, include: '**'
    end
  end

  def load_post_dev
    if ['posts/likes', 'posts/pins', 'posts/favorites', 'posts/recommendations'].include? controller_path
      @parent = Post.first
    end
  end
end
