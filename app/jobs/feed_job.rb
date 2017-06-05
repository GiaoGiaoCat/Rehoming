class FeedJob < ApplicationJob
  queue_as :feed

  def perform(event_name, sourceable, feed_owner_ids)
    User.where(id: feed_owner_ids).find_each do |user|
      user.feeds.create!(sourceable: sourceable, event: event_name)
    end
  end
end
