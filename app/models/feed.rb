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
  attribute :event, :string
  %i(created_at updated_at).each { |attr| attribute attr, :datetime, default: proc { Time.current } }

  # redundant data
  attribute :forum_id, :integer
  attribute :forum_name, :string
  attribute :content, :string
  attribute :creator_id, :integer
  attribute :creator_nickname, :string
  attribute :creator_avatar, :string
  attribute :attachments

  belongs_to :sourceable, polymorphic: true
  belongs_to :user
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id

  before_save :generate_uuid
  before_save :touch_timestamps
  after_save :persist!

  delegate :forum, to: :sourceable

  def self.generate_cache_key(id)
    "feeds/#{id}"
  end

  def cache_key
    Feed.generate_cache_key(id)
  end

  def make_as_read!
    self.read = true and save
    decrease_user_feeds_count
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

  def decrease_user_feeds_count
    user.feeds_count.decrement
  end
end
