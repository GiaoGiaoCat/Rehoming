class Feeds::FetchMultiService < ApplicationService
  attribute :keys
  attribute :objects

  validates :keys, presence: true

  private

  def perform
    self.objects = fetch_multi(keys)
  end

  def fetch_multi(keys)
    keys.each_with_object([]) do |k, objects|
      data = redis.get(k)
      objects << Feed.new.from_json(data) if data
    end
  end

  def redis
    Redis.current
  end
end
