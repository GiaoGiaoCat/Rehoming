class Services::Feeds::Create < ApplicationService
  def call(name, _transaction_id, payload)
    method_name = name.sub('.', '_').to_sym
    @sourceable = payload[:sourceable]
    @handler = payload[:handler]
    send(method_name) if private_methods.include? method_name
  end

  private

  # 点赞一条回复 -> 给被赞的回复作者发送动态
  def liked_comment
    common_feed('new_like_of_comment')
  end

  # 点赞一条主题 -> 给被赞的题主发送动态
  def liked_post
    common_feed('new_like_of_post')
  end

  # 添加一条评论 -> 给被回复的题主发送动态
  def commented_post
    common_feed('new_comment_of_post')
  end

  # 回复中提及某人 -> 给被提及者发送动态
  def replied_comment
    replied_user_id = @sourceable.replied_user_id
    return if replied_user_id.blank?
    return if replied_user_id == @handler.id || replied_user_id == @sourceable.commentable.author.id
    feed_job 'new_reply_of_comment', @sourceable.replied_user_id
  end

  # 添加一条主题 -> 给主题所在的圈子中，题主之外的所有成员发送动态
  def created_post
    user_id = @sourceable.user_id
    member_ids = @sourceable.forum.members.feed_allowed.map(&:id).delete_if { |member_id| member_id == user_id }
    feed_job 'new_post', member_ids
  end

  def common_feed(event_name)
    return if @sourceable.author == @handler || disable_feed?
    feed_job event_name, @sourceable.author.id
  end

  def disable_feed?
    feed_owner ||= @sourceable.author
    preference = feed_owner.forum_preferences.find_by(forum: @sourceable.forum)
    !preference.feed_allowed
  end

  def feed_job(event_name, feed_owner_ids)
    FeedJob.perform_later(event_name, @sourceable, feed_owner_ids)
  end
end
