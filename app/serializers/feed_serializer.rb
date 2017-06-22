class FeedSerializer < ApplicationSerializer
  cache key: 'feed'

  attributes :event, :read, :forum_name, :content

  def event
    Feed::EVENTS.fetch(object.event.to_sym)
  end
end
