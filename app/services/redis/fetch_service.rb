class Redis::FetchService < ApplicationService
  attribute :key
  attribute :object

  validates :key, presence: true

  private

  def perform
    self.object = fetch(key)
  end

  def fetch(key)
    data = redis.get(key)
    Marshal.load(data) if data
  end

  def redis
    Redis.current
  end
end
