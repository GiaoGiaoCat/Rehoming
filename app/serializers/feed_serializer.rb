class FeedSerializer < ApplicationSerializer
  cache key: 'feed'

  attributes :event, :read

  belongs_to :sourceable

  def event
    Feed::EVENTS.fetch(object.event.to_sym)
  end
end
