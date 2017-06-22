require 'test_helper'

class Redis::FetchServiceTest < ActiveSupport::TestCase
  setup do
    params = {
      id: SecureRandom.uuid,
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:roc).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    @feed = Feed.create(params)
  end

  test '根据 key 从 redis 中获取数据' do
    fetch = Redis::FetchService.new(key: @feed.cache_key)
    assert fetch.save
    assert_equal @feed, fetch.object
  end
end
