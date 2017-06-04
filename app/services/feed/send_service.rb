class Feed::SendService
  prepend SimpleCommand

  def initialize(name, transaction_id, payload)
    @transaction_id = transaction_id
    @obj_id = payload[:obj_id]
    @handler_id = payload[:handler_id]
    @method_name = name.sub('.', '_').to_sym
    @source_class = name.split('.').last.to_s.camelize.constantize
    @source_obj = @source_class.find_by(id: @obj_id)
  end

  def call
    send(@method_name) if private_methods.include? @method_name
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
    replied_user_id = @source_obj.replied_user_id
    return if replied_user_id.blank?
    return if replied_user_id == @handler_id || replied_user_id == @source_obj.commentable.author.id
    feed_job 'new_reply_of_comment', @source_obj.replied_user_id
  end

  # 添加一条主题 -> 给主题所在的圈子中，题主之外的所有成员发送动态
  def created_post
    user_id = @source_obj.user_id
    member_ids = @source_obj.forum.members.feed_allowed.map(&:id).delete_if { |member_id| member_id == user_id }
    feed_job 'new_post', member_ids
  end

  def common_feed(event_name)
    return if @source_obj.author.id == @handler_id || disable_feed?
    feed_job event_name, @source_obj.author.id
  end

  def disable_feed?
    feed_owner ||= @source_obj.author
    preference = feed_owner.forum_preferences.find_by(forum: @source_obj.forum)
    !preference.feed_allowed
  end

  def feed_job(event_name, feed_owner_ids)
    FeedJob.perform_later(event_name, @obj_id, @source_class.to_s, feed_owner_ids)
  end
end
