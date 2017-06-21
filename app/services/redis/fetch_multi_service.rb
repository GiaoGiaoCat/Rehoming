class Redis::FetchMultiService < ApplicationService
  attribute :keys
  attribute :objects

  validates :keys, presence: true

  private

  def perform
    self.objects = fetch_multi(keys)
  end

  def fetch_multi(keys)
    keys.inject([]) do |objects, k|
      data = redis.get(k)
      objects << Marshal.load(data) if data
    end
  end

  def redis
    Redis.current
  end
end
