class FeedSerializer < ApplicationSerializer
  cache key: 'feed'

  attributes :event, :read, :forum_name, :content, :creator_nickname, :creator_avatar, :attachments

  def event
    Feed::EVENTS.fetch(object.event.to_sym)
  end

  def attachments
    JSON.parse object.attachments
  end
end
