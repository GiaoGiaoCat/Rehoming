require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test 'should show post' do
    get post_url(@post), headers: @headers
    assert_response :success
  end
end
