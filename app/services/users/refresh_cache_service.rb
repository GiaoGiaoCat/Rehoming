class Users::RefreshCacheService < ApplicationService
  attribute :name, :string
  attribute :sourceable
  attribute :handler

  validates :name, presence: true
  validates :sourceable, presence: true
  validates :handler, presence: true

  private

  def perform
    encrypted_id = sourceable.to_param
    Rails.cache.write encrypted_id, Marshal.dump(sourceable)
  end
end
