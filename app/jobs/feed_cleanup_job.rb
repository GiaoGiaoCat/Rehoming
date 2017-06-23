class FeedCleanupJob < ApplicationJob
  queue_as :feed_cleanup

  def perform(key)
    delete_feed(key)
  end

  private

  def delete_feed(key)
    Feeds::DeleteService.create(key: key)
  end
end
