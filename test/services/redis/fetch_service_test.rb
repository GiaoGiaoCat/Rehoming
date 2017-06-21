require 'test_helper'

class Redis::FetchServiceTest < ActiveSupport::TestCase
  setup do
    params = {
      id: SecureRandom.uuid,
      sourceable_id: Post.first.id, sourceable_type: Post.first.class, user_id: User.first.id, event: 'new_post'
    }
    @feed = Feed.create(params)
  end

  test '根据 key 从 redis 中获取数据' do
    fetch = Redis::FetchService.new(key: @feed.cache_key)
    assert fetch.save
    assert_equal @feed, fetch.object
  end
end
