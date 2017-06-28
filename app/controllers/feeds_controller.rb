class FeedsController < ApplicationController
  def index
    load_feeds
    options = { each_serializer: FeedSerializer }
    render json: explicit_serializer(@feeds, options).as_json
  end

  def update
    load_feed
    @feed.make_as_read!
    render json: @feed
  end

  private

  def load_feeds
    cache_keys = Kaminari.paginate_array(current_user.feeds.value).page(pagination_number).per(25)
    fetch = Feeds::FetchMultiService.new(keys: cache_keys)
    @feeds = fetch.save ? fetch.objects : []
  end

  def load_feed
    cache_key = Feed.generate_cache_key(params[:id])
    fetch = Feeds::FetchService.new(key: cache_key)
    @feed = fetch.save ? fetch.object : nil
  end
end
