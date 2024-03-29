class Feeds::SendService < ApplicationService
  attribute :name, :string
  attribute :sourceable
  attribute :handler

  validates :name, presence: true
  validates :sourceable, presence: true
  validates :handler, presence: true

  private

  def perform
    method_name = name.sub('.', '_').to_sym
    send(method_name) if private_methods.include? method_name
  end

  # 点赞一条回复 -> 给被赞的回复作者发送动态
  def liked_comment
    common_feed('new_like_of_comment')
  end

  # 点赞一条主题 -> 给被赞的题主发送动态
  def liked_post
    common_feed('new_like_of_post')
  end

  # 添加一条评论 -> 给被回复的题主发送动态
  # 1. 评论者和被回复主题作者相同，不发送动态
  # 2. 评论中提及被回复主题作者，不发送动态
  # 3. 被回复主题作者关闭通知，不发送动态
  def commented_post
    replied_user_id = sourceable.replied_user_id
    author_id = sourceable.commentable.author.id
    return if [handler.id, replied_user_id].include?(author_id) || disable_feed?
    seed_feed 'new_comment_of_post', author_id
  end

  # 回复中提及某人 -> 给被提及者发送动态
  def replied_comment
    replied_user_id = sourceable.replied_user_id
    return if replied_user_id.blank? || handler.id == replied_user_id
    seed_feed 'new_reply_of_comment', sourceable.replied_user_id
  end

  # 添加一条主题 -> 给主题所在的圈子中，题主之外的所有成员发送动态
  def created_post
    user_id = sourceable.user_id
    member_ids = sourceable.forum.members.feed_allowed.map(&:id).reject { |member_id| member_id == user_id }
    seed_feed 'new_post', member_ids
  end

  def common_feed(event_name)
    return if sourceable.author == handler || disable_feed?
    seed_feed event_name, sourceable.author.id
  end

  def disable_feed?
    feed_owner ||= sourceable.author
    preference = feed_owner.forum_preferences.find_by(forum: sourceable.forum)
    !preference.feed_allowed
  end

  def seed_feed(event_name, feed_owner_ids)
    feed_owner_ids = [feed_owner_ids] if feed_owner_ids.is_a?(Integer)
    feed_owner_ids.each_slice(100) do |batch|
      batch.each { |user_id| FeedJob.perform_later(event_name, sourceable, handler, user_id) }
    end
  end
end
