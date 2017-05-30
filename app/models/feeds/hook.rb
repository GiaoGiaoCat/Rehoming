class Feeds::Hook < ActiveType::Object
  attribute :name, :string
  attribute :transaction_id, :string
  attribute :payload, :hash

  validates :name, presence: true
  validates :transaction_id, presence: true
  validates :payload, presence: true

  after_save :feed

  private

  # TODO: 实现根据 payload 的数据，创建 feed，并扔到 jobs 中，不影响主线程操作事件
  def feed
    method_name = name.sub('.', '_').to_sym
    send(method_name) if private_methods.include? method_name
  end

  def source_class
    name.split('.').last.to_s.camelize.constantize
  end

  def source
    # REVIEW: payload 在产品环境可能需要 symbolize_keys
    @source ||= source_class.find_by(id: payload[:obj_id])
  end

  def liked_comment
    return if source.author == payload[:handler_id]
    source.author.feeds.create(sourceable: source, event: 'new_like_of_comment')
  end

  def liked_post
    return if source.author == payload[:handler_id]
    source.author.feeds.create(sourceable: source, event: 'new_like_of_post')
  end

  # def liked_comment
  #   return feed_commentable_author if source.replied_user_id.blank?
  #   feed_replied_user
  #   feed_commentable_author if source.replied_user_id != source.author.id
  # end

  # 发送给被题主的动态
  # def feed_commentable_author
  #   source.commentable.author.feeds.create(sourceable: source, event: 'new_comment_of_post')
  # end

  # 发送给被回复者的动态
  # def feed_replied_user
  #   source.replied_user.feeds.create(sourceable: source, event: 'new_comment_of_comment')
  # end
end
