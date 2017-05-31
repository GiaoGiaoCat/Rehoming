class Feeds::Hook < ActiveType::Object
  attribute :name, :string
  attribute :transaction_id, :string
  attribute :payload, :hash

  validates :name, presence: true
  validates :transaction_id, presence: true
  validates :payload, presence: true

  after_save :feed

  private

  def feed
    method_name = name.sub('.', '_').to_sym
    send(method_name) if private_methods.include? method_name
  end

  def source_class
    @source_class ||= name.split('.').last.to_s.camelize.constantize
  end

  def source_obj
    # REVIEW: payload 在产品环境可能需要 symbolize_keys
    @source ||= source_class.find_by(id: payload[:obj_id])
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
  def commented_post
    common_feed('new_comment_of_post')
  end

  # 回复中提及某人 -> 给被提及者发送动态
  def replied_comment
    return if source_obj.replied_user_id.blank?
    return if source_obj.replied_user_id == payload[:handler_id]
    return if source_obj.replied_user_id == source_obj.commentable.author.id
    feed_job 'new_reply_of_comment', source_obj.replied_user_id
  end

  # 添加一条主题 -> 给主题所在的圈子中，题主之外的所有成员发送动态
  def created_post
    user_id = source_obj.user_id
    member_ids = source_obj.forum.member_ids.delete_if { |member_id| member_id == user_id }
    feed_job 'new_post', member_ids
  end

  def common_feed(event_name)
    return if source_obj.author.id == payload[:handler_id]
    feed_job event_name, source_obj.author.id
  end

  def feed_job(event_name, feed_owner_ids)
    FeedJob.perform_later(event_name, payload[:obj_id], source_class.to_s, feed_owner_ids)
  end
end
