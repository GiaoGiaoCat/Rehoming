class FeedsController < ApplicationController
  def index
    load_feeds
    render json: @feeds, include: [:sourceable]
  end

  def update
    build_feed
    @feed.make_as_read!
    head :no_content
  end

  private

  def load_feeds
    feed_keys = Kaminari.paginate_array(current_user.feeds.value).page(pagination_number).per(10)
    # @feeds = Feeds::FetchService.create(keys: feed_keys)
  end

  def build_feed
    @feed = current_user.feeds.find(params[:id])
  end
end
