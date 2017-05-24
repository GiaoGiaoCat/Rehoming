require 'test_helper'

class ForumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
  end

  test "should get show" do
    get forum_url(@forum), headers: @headers
    assert_response :success
  end
end
