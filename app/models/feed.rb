class Feed < ActiveType::Object
  EVENTS = {
    new_post:               10,
    new_comment_of_post:    20,
    new_reply_of_comment:   30,
    new_like_of_post:       40,
    new_like_of_comment:    50
  }.freeze

  attribute :id, :string
  attribute :read, :boolean, default: false
  attribute :sourceable_id, :integer
  attribute :sourceable_type, :string
  attribute :user_id, :integer
  # NOTE: 不要给 event 指定 integer 或 string 类型，这里需求输入的是 string 输出的是 integer
  # HACK: 可以移动到 serializer 中实现
  attribute :event
  %i(created_at updated_at).each { |attr| attribute attr, :datetime, default: proc { Time.current } }

  belongs_to :sourceable, polymorphic: true
  belongs_to :user

  before_save :generate_uuid
  before_save :touch_timestamps
  after_save :persist!

  def cache_key
    "feeds/#{id}"
  end

  def make_as_read!
    self.read = true
    save
    user.feeds_count.decrement
  end

  private

  def persist!
    Feeds::PersistenceService.create(key: cache_key, feed: self)
  end

  def generate_uuid
    self.id ||= SecureRandom.uuid
  end

  def touch_timestamps
    self.updated_at = Time.current
  end
end
