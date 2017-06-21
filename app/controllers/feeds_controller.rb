class FeedsController < ApplicationController
  def index
    load_feeds
    render json: @feeds, include: [:sourceable]
  end

  def update
    load_feed
    @feed.make_as_read!
    head :no_content
  end

  private

  def load_feeds
    feed_keys = Kaminari.paginate_array(current_user.feeds.value).page(pagination_number).per(10)
    fetch = Redis::FetchMultiService.new(keys: feed_keys)
    @feeds = fetch.save ? fetch.objects : []
  end

  def load_feed
    fetch = Redis::FetchService.new(key: "feeds/#{params[:id]}")
    @feed = fetch.save ? fetch.object : nil
  end
end
