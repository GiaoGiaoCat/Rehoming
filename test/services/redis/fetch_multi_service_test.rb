require 'test_helper'

class Redis::FetchMultiServiceTest < ActiveSupport::TestCase
  setup do
    params = {
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:roc).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    @feed_a = Feeds::CreateForm.create(params).object
    @feed_b = Feeds::CreateForm.create(params).object
  end

  test '根据 key 从 redis 中获取数据' do
    keys = [@feed_a.cache_key, @feed_b.cache_key]
    fetch = Redis::FetchMultiService.new(keys: keys)
    assert fetch.save
    assert_equal [@feed_a, @feed_b], fetch.objects
  end
end
