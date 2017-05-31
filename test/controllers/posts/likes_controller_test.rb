require 'test_helper'

class Posts::LikesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @victor = users(:victor)
    @post_liked = posts(:one)
    @post_unliked = posts(:three)
  end

  test 'should create likes' do
    assert_difference -> { @victor.likes.count } do
      post post_likes_url(@post_unliked), headers: @headers
    end
    assert_response :success
    assert_equal 201, @response.status
  end

  test 'create likes should feed' do
    assert_difference -> { users(:yuki).feeds.count } do
      job_params = ['new_like_of_post', @post_unliked.id, 'Post', @post_unliked.author.id]
      assert_performed_with(job: FeedJob, args: job_params, queue: 'feed') do
        post post_likes_url(@post_unliked), headers: @headers
      end
    end
  end

  test 'create likes should not feed when post author is current user' do
    assert_no_difference -> { @victor.feeds.count } do
      assert_no_performed_jobs do
        post post_likes_url(posts(:two)), headers: @headers
      end
    end
  end

  test 'should destroy likes' do
    assert_difference -> { @victor.likes.count }, -1 do
      delete post_likes_url(@post_liked), headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end
end
