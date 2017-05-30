require 'test_helper'

class Posts::LikesControllerTest < ActionDispatch::IntegrationTest
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
      post post_likes_url(@post_unliked), headers: @headers
    end
  end

  test 'create likes should not feed when post author is current user' do
    assert_difference -> { @victor.feeds.count } do
      post post_likes_url(posts(:two)), headers: @headers
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
