class Feeds::CreateForm < ApplicationForm
  ATTRS = %i(id sourceable_id sourceable_type user_id event).freeze
  ATTRS.each { |attr| delegate attr.to_sym, "#{attr}=".to_sym, to: :object }

  validates :event, inclusion: { in: Feed::EVENTS.values }

  before_validation :correct_enum_value
  before_save :generate_uuid

  private

  def correct_enum_value
    return if event.blank? || event.is_a?(Integer)
    self.event = Feed::EVENTS.fetch(event.to_sym)
  end

  # TODO: 没有在 redis 中判断 id 是否会重复
  def generate_uuid
    # self.id ||= loop do
    #   random_token = SecureRandom.uid
    #   break random_token unless self.class.exists?(guest_token: random_token)
    # end
    self.id ||= SecureRandom.uuid
  end

  def sync
    object.save
    Feeds::PersistenceService.create(key: "feeds/#{id}", feed: object)
    object.user.feeds_count.increment
  end
end
