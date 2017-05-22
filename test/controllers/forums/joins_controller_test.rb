require 'test_helper'

class Forums::JoinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
  end

  test 'should create join' do
    post forum_join_url(@forum), headers: @headers
    assert_response :success
  end
end
