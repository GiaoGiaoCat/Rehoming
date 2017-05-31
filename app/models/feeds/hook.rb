class Feeds::Hook < ActiveType::Object
  attribute :name, :string
  attribute :transaction_id, :string
  attribute :payload, :hash

  validates :name, presence: true
  validates :transaction_id, presence: true
  validates :payload, presence: true

  after_save :feed

  private

  # 根据 payload 的数据，创建 feed，并扔到 jobs 中，不影响主线程操作事件
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

  def liked_comment
    common_feed('new_like_of_comment')
  end

  def liked_post
    common_feed('new_like_of_post')
  end

  # 评论后给给题主发送动态
  def commented_post
    common_feed('new_comment_of_post')
  end

  # 回复某人后给被回复者发送动态
  def replied_comment
    return if source_obj.replied_user_id.blank? || source_obj.replied_user_id == payload[:handler_id]
    feed_job 'new_reply_of_comment', feed_owner_id: source_obj.replied_user_id
  end

  # 圈子有新帖提示圈子成员
  def created_post
    # Feeds::PostJob.perform_later(source_obj.forum.member_ids, source_obj.id)
    user_id = source_obj.user_id
    member_ids = source_obj.forum.member_ids.delete_if { |member_id| member_id == user_id }
    feed_job 'new_post', feed_owner_ids: member_ids
  end

  def common_feed(event_name)
    return if source_obj.author.id == payload[:handler_id]
    feed_job event_name, feed_owner_id: source_obj.author.id
  end

  def feed_job(event_name, args = {})
    # perform(event_name, source_id, source_class, args = {})
    FeedJob.perform_later(event_name, payload[:obj_id], source_class.to_s, args)
  end
end