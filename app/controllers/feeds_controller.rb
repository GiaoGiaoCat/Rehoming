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
    @feeds = current_user.feeds
  end

  def build_feed
    @feed = current_user.feeds.find_by_encrypted_id(params[:id])
  end
end
