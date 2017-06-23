require 'test_helper'

class Feeds::DeleteServiceTest < ActiveSupport::TestCase
  setup do
    params = {
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:roc).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    @feed = Feeds::CreateForm.create(params).object
  end

  test '从 redis 中删除 feed' do
    assert_changes -> { @feed.user.reload.feeds.value.size }, -1 do
      delete = Feeds::DeleteService.new(key: @feed.cache_key)
      assert delete.save
      assert_not Redis.current.get(@feed.cache_key)
    end
  end
end
