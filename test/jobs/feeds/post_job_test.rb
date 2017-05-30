require 'test_helper'

class Feeds::PostJobTest < ActiveJob::TestCase
  test '发贴之后，给除了自己以外的所有其他会员发送动态' do
    assert_difference 'Feed.count', forums(:one).members.count - 1 do
      Feeds::PostJob.perform_now(forums(:one).member_ids, posts(:one).id)
    end
  end
end
