class Feeds::DeleteService < ApplicationService
  attribute :key, :string
  attribute :feed

  validates :key, presence: true

  before_save :ensure_feed

  delegate :user, to: :feed

  private

  def perform
    cleanup_feed_owner if feed
    Redis.current.del key
  end

  def ensure_feed
    fetch = Feeds::FetchService.create(key: key)
    self.feed = fetch.object if fetch
  end

  def cleanup_feed_owner
    user.feeds.delete key
  end
end
