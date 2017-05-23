require 'test_helper'

class ForumsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get forums_show_url
    assert_response :success
  end

end
