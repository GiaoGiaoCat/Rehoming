require 'test_helper'

class Forums::MembershipsControllerTest < ActionDispatch::IntegrationTest
  test 'should destroy membership' do
    assert_difference -> { Forums::Membership.active.count }, -1 do
      delete forum_membership_url(forums(:one)), headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end
end
