require 'test_helper'

class Forums::MembersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get forum_members_url(forums(:one)), headers: @headers
    assert_response :success
  end
end
