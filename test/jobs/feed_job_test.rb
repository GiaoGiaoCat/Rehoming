require 'test_helper'

class FeedJobTest < ActiveJob::TestCase
  setup do
    @forum = forums(:one)
    @comment = comments(:three)
  end

  test 'create feed' do
    assert_difference -> { users(:yuki).feeds.count } do
      FeedJob.perform_now('new_like_of_comment', @comment, @comment.author.id)
    end
  end

  test 'create feeds' do
    assert_difference -> { Feed.count }, @forum.members.count do
      FeedJob.perform_now('new_post', posts(:one), @forum.member_ids)
    end
  end
end
