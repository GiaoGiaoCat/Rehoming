require 'test_helper'

class Posts::LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @post_liked = posts(:one)
    @post_unliked = posts(:two)
  end

  test 'should create likes' do
    assert_difference -> { @victor.likes.count } do
      post post_likes_url(@post_unliked), headers: @headers
    end
    assert_response :success
    assert_equal 201, @response.status
  end

  test 'should destroy likes' do
    assert_difference -> { @victor.likes.count }, -1 do
      delete post_likes_url(@post_liked), headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end
end
