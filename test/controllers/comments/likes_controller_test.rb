require 'test_helper'

class Comments::LikesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @victor = users(:victor)
    @comment_liked = comments(:one)
    @comment_unliked = comments(:three)
  end

  test 'should create likes' do
    assert_difference -> { @victor.likes.count } do
      post comment_likes_url(@comment_unliked), headers: @headers
    end
    assert_response :success
    assert_equal 201, @response.status
  end

  test 'create likes should feed' do
    assert_difference -> { users(:yuki).feeds_count.value } do
      job_params = ['new_like_of_comment', @comment_unliked, @victor, [@comment_unliked.author.id]]
      assert_performed_with(job: FeedJob, args: job_params, queue: 'feed') do
        post comment_likes_url(@comment_unliked), headers: @headers
      end
    end
  end

  test 'create likes should not feed when comment author is current user' do
    assert_no_difference -> { @victor.feeds_count.value } do
      assert_no_performed_jobs do
        post comment_likes_url(comments(:two)), headers: @headers
      end
    end
  end

  test 'should destroy likes' do
    assert_difference -> { @victor.likes.count }, -1 do
      delete comment_likes_url(@comment_liked), headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end
end
