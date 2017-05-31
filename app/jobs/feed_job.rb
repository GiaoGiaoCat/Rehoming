class FeedJob < ApplicationJob
  queue_as :feed

  def perform(event_name, source_id, source_class, feed_owner_ids)
    source_obj = source_class.constantize.find_by(id: source_id)
    User.where(id: feed_owner_ids).find_each do |user|
      user.feeds.create!(sourceable: source_obj, event: event_name)
    end
  end
end
