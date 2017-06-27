class Feeds::CreateForm < ApplicationForm
  ATTRS = %i(
    sourceable_id sourceable_type user_id event
    forum_id forum_name content
    creator_id creator_nickname creator_avatar
    attachments
  ).freeze
  ATTRS.each { |attr| delegate attr, "#{attr}=".to_sym, to: :object }
  %i(user sourceable forum creator).each { |attr| delegate attr, to: :object }

  validates :event, inclusion: { in: Feed::EVENTS.keys.map(&:to_s) }

  private

  def sync
    return unless object.save
    user.feeds_count.increment
    user.feeds << object.cache_key
    schedule_cleanup_task
  end

  def setup_object_attributes
    copy_content
    copy_forum
    copy_creator
  end

  def copy_content
    self.content ||= sourceable.content
    self.attachments ||= sourceable.attachments.to_json
  end

  def copy_forum
    self.forum_id ||= forum.id
    self.forum_name ||= forum.name
  end

  def copy_creator
    self.creator_id ||= creator_id
    self.creator_nickname ||= creator.forum_nickname(forum)
    self.creator_avatar ||= creator.headimgurl
  end

  def schedule_cleanup_task
    FeedCleanupJob.set(wait: 2.weeks).perform_later(object.cache_key)
  end
end
