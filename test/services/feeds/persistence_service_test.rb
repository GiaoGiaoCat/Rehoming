require 'test_helper'

class Feeds::PersistenceServiceTest < ActiveSupport::TestCase
  setup do
    params = {
      id: SecureRandom.uuid,
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:roc).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    @feed = Feed.create(params)
  end

  test '持久化到 redis 中' do
    Redis.current.del(@feed.cache_key)

    persistence = Feeds::PersistenceService.new(key: @feed.cache_key, feed: @feed)
    assert persistence.save
    assert Redis.current.get(@feed.cache_key)
  end
end
