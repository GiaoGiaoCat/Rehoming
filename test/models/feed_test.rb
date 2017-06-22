require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  setup do
    params = {
      id: SecureRandom.uuid,
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      user_id: users(:victor).id,
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

  test 'append_data callback when sourceable is a post' do
    assert @feed.forum_id
    assert @feed.forum_name
    assert posts(:one).content, @feed.content
  end

  test 'append_data callback when sourceable is a comment' do
    params = {
      id: SecureRandom.uuid,
      sourceable_id: comments(:one).id, sourceable_type: comments(:one).class,
      user_id: users(:victor).id,
      event: 'commented.post'
    }
    feed = Feed.create(params)

    assert feed.forum_id
    assert feed.forum_name
    assert_equal comments(:one).content, feed.content
  end
end
