require 'test_helper'

class Feeds::FetchServiceTest < ActiveSupport::TestCase
  setup do
    params = {
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:roc).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    @feed = Feeds::CreateForm.create(params).object
  end

  test '根据 key 从 redis 中获取数据' do
    fetch = Feeds::FetchService.new(key: @feed.cache_key)
    assert fetch.save
    assert_equal @feed, fetch.object
  end
end
