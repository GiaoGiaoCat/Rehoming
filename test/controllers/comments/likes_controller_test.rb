require 'test_helper'

class Comments::LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @comment_liked = comments(:one)
    @comment_unliked = comments(:two)
  end

  test 'should create likes' do
    assert_difference -> { @victor.likes.count } do
      post comment_likes_url(@comment_unliked), headers: @headers
    end
    assert_response :success
    assert_equal 201, @response.status
  end

  test 'should destroy likes' do
    assert_difference -> { @victor.likes.count }, -1 do
      delete comment_likes_url(@comment_liked), headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end
end
