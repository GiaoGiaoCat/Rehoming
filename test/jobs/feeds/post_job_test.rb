require 'test_helper'

class Feeds::PostJobTest < ActiveJob::TestCase
  test '发贴之后，给除了自己以外的所有其他会员发送动态' do
    forum_one = forums(:one)
    assert_difference 'Feed.count', forum_one.members.count - 1 do
      Feeds::PostJob.perform_now(forum_one.members.ids, posts(:one).id)
    end
  end
end
