class FeedJob < ApplicationJob
  queue_as :feed

  def perform(event_name, source_id, source_class, args = {})
    case event_name
    when 'new_like_of_comment', 'new_like_of_post', 'new_comment_of_post', 'new_reply_of_comment'
      feed_to_user(event_name, source_id, source_class, args)
    when 'new_post'
      feed_to_members(event_name, source_id, source_class, args)
    end
  end

  private

  def feed_to_members(event_name, source_id, source_class, args = {})
    source_obj = source_class.constantize.find_by(id: source_id)
    User.where(id: args[:feed_owner_ids]).find_each do |user|
      user.feeds.create!(sourceable: source_obj, event: event_name)
    end
  end

  def feed_to_user(event_name, source_id, source_class, args = {})
    source_obj = source_class.constantize.find_by(id: source_id)
    user = User.find_by(id: args[:feed_owner_id])
    user.feeds.create(sourceable: source_obj, event: event_name)
  end
end
