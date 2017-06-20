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
  attribute :event
  %i(created_at updated_at).each { |attr| attribute attr, :datetime, default: proc { Time.current } }

  belongs_to :sourceable, polymorphic: true
  belongs_to :user

  validates :event, inclusion: { in: Feed::EVENTS.values }

  before_validation :correct_enum_value
  before_save :generate_uuid
  before_save :touch_timestamps
  after_save :redis_persistence

  def make_as_read
    self.read = true
    save
  end

  private

  def correct_enum_value
    return if event.blank? || event.is_a?(Integer)
    self.event = Feed::EVENTS.fetch(event.to_sym)
  end

  def touch_timestamps
    self.updated_at = Time.current
  end

  # TODO: 没有在 redis 中判断 id 是否会重复
  def generate_uuid
    # self.id ||= loop do
    #   random_token = SecureRandom.uid
    #   break random_token unless self.class.exists?(guest_token: random_token)
    # end
    self.id ||= SecureRandom.uuid
  end

  def redis_persistence
    Redis.current.hmset("feeds/#{id}", *attributes)
  end
end
