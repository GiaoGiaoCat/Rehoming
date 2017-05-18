require 'test_helper'

class Posts::PinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
  end

  test 'should create pin' do
    assert_no_difference('Post.sticky.count') do
      post post_pin_url(@post_one), headers: @headers
    end

    assert_response :success
    assert_equal 201, @response.status
  end
end
