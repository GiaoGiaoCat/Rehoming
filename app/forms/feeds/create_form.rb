class Feeds::CreateForm < ApplicationForm
  ATTRS = %i(
    sourceable_id sourceable_type user_id creator_id event
    forum_id forum_name content
  ).freeze
  ATTRS.each { |attr| delegate attr, "#{attr}=".to_sym, to: :object }
  %i(user sourceable forum).each { |attr| delegate attr, to: :object }

  validates :event, inclusion: { in: Feed::EVENTS.keys.map(&:to_s) }

  private

  def sync
    return unless object.save
    user.feeds_count.increment
    user.feeds << cache_key
  end

  def setup_object_attributes
    self.forum_id ||= forum.id
    self.forum_name ||= forum.name
    self.content ||= sourceable.content
    # self.creator_id ||=
    # self.creator_nickname ||=
    # self.creator_avatar ||=
  end
end
