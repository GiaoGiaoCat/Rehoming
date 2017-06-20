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

  before_save :touch_timestamps

  def make_as_read
    self.read = true
    user.feeds_count.decrement
    save
  end

  private

  def touch_timestamps
    self.updated_at = Time.current
  end
end
