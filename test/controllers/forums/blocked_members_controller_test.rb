require 'test_helper'

class Forums::BlockedMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
    @victor = users(:victor)
  end

  test 'should create blocked member' do
    params_data = { data: { attributes: { user_id: @victor.to_param } } }

    assert_difference -> { @forum.forum_memberships.blocked.count } do
      post forum_blocked_member_url(@forum), params: params_data, headers: @headers
    end
    assert_response :success
  end
end
