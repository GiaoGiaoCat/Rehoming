class FeedCleanupJob < ApplicationJob
  queue_as :feed_cleanup

  def perform(key)
    Feeds::DeleteService.create key: key
  end
end
