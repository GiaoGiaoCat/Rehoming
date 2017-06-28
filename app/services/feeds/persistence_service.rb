class Feeds::PersistenceService < ApplicationService
  attribute :key, :string
  attribute :feed

  validates :key, presence: true
  validates :feed, presence: true

  private

  def perform
    Redis.current.set key, feed.to_json
  end
end
