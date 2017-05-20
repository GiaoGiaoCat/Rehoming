require 'test_helper'

class Posts::PinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @post_pined = posts(:one)
    @post_unpined = posts(:two)
  end

  test 'should create pin' do
    assert_no_difference -> { Post.sticky.count } do
      post post_pin_url(@post_unpined), headers: @headers
    end

    assert_response :success
    assert_equal 201, @response.status
  end

  test 'should destroy pin' do
    assert_difference -> { Post.sticky.count }, -1 do
      delete post_pin_url(@post_pined), headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end
end
