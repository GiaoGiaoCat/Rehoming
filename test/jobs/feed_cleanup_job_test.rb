require 'test_helper'

class FeedCleanupJobTest < ActiveJob::TestCase
  setup do
    params = {
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:roc).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    @feed = Feeds::CreateForm.create(params).object
  end

  test 'cleanup feed' do
    assert_difference -> { users(:victor).feeds.value.size }, -1 do
      FeedCleanupJob.perform_now(@feed.cache_key)
    end
  end
end
