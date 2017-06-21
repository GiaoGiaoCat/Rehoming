class Feeds::CreateForm < ApplicationForm
  ATTRS = %i(sourceable_id sourceable_type user_id event).freeze
  ATTRS.each { |attr| delegate attr, "#{attr}=".to_sym, to: :object }
  %i(id cache_key user).each { |attr| delegate attr, to: :object }

  validates :event, inclusion: { in: Feed::EVENTS.keys.map(&:to_s) }

  private

  def sync
    object.save
    user.feeds_count.increment
    user.feeds << cache_key
  end
end
