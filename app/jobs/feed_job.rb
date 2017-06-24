class FeedJob < ApplicationJob
  queue_as :feed

  def perform(event_name, sourceable, creator, feed_owner_id)
    Feeds::CreateForm.create(
      sourceable_id: sourceable.id,
      sourceable_type: sourceable.class,
      creator_id: creator.id,
      event: event_name,
      user_id: feed_owner_id
    )
  end
end
