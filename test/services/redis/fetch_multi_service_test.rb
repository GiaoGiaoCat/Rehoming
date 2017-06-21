require 'test_helper'

class Redis::FetchMultiServiceTest < ActiveSupport::TestCase
  setup do
    params = {
      id: SecureRandom.uuid,
      sourceable_id: Post.first.id, sourceable_type: Post.first.class, user_id: User.first.id, event: 'new_post'
    }
    @feed_a = Feed.create(params)
    @feed_b = Feed.create(params.merge(id: SecureRandom.uuid))
  end

  test '根据 key 从 redis 中获取数据' do
    keys = [@feed_a.cache_key, @feed_b.cache_key]
    fetch = Redis::FetchMultiService.new(keys: keys)
    assert fetch.save
    assert_equal [@feed_a, @feed_b], fetch.objects
  end
end
