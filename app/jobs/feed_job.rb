class FeedJob < ApplicationJob
  queue_as :feed

  def perform(event_name, sourceable, creator, feed_owner_ids = [])
    params = {
      sourceable_id: sourceable.id, sourceable_type: sourceable.class, creator_id: creator.id,
      event: event_name
    }
    feed_owner_ids.each_slice(100) do |batch|
      batch.each { |user_id| Feeds::CreateForm.create params.merge(user_id: user_id) }
    end
  end
end
