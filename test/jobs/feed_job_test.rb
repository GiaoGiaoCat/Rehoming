require 'test_helper'

class FeedJobTest < ActiveJob::TestCase
  setup do
    @forum = forums(:one)
    @comment = comments(:three)
  end

  test 'create feed' do
    assert_difference -> { users(:yuki).feeds_count.value } do
      FeedJob.perform_now('new_like_of_comment', @comment, users(:victor), @comment.author.id)
    end
  end
end
