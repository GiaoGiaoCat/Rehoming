class FeedsController < ApplicationController
  def index
    load_feeds
    render json: @feeds
  end

  def update
    load_feed
    @feed.make_as_read!
    head :no_content
  end

  private

  def load_feeds
    cache_keys = Kaminari.paginate_array(current_user.feeds.value).page(pagination_number).per(25)
    fetch = Redis::FetchMultiService.new(keys: cache_keys)
    @feeds = fetch.save ? fetch.objects : []
  end

  def load_feed
    cache_key = Feed.generate_cache_key(params[:id])
    fetch = Redis::FetchService.new(key: cache_key)
    @feed = fetch.save ? fetch.object : nil
  end
end
