require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  setup do
    params = {
      id: SecureRandom.uuid,
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:roc).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    @feed = Feed.create(params)
  end

  test 'make_as_read should change read and touch_timestamps' do
    assert_changes -> { @feed.updated_at } do
      assert_difference -> { users(:victor).feeds_count.value }, -1 do
        @feed.make_as_read!
      end
    end
    assert @feed.read
  end

  test 'generate_uuid callback' do
    assert @feed.id
  end
end
