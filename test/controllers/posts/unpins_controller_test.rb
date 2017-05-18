require 'test_helper'

class Posts::UnpinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
  end

  test 'should create pin' do
    assert_difference -> { Post.sticky.count }, -1 do
      post post_unpin_url(@post_one), headers: @headers
    end

    assert_response :success
    assert_equal 201, @response.status
  end
end
