require 'test_helper'

class Forums::BlockedMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
    @victor = users(:victor)
  end

  test 'should create blocked member' do
    params_data = { data: { attributes: { user_id: @victor.to_param } } }

    assert_difference -> { @forum.memberships.blocked.count } do
      post forum_blocked_member_url(@forum), params: params_data, headers: @headers
    end

    assert_response :success
  end

  test 'should destroy blocked member' do
    block_victor_at_first

    params_data = { data: { attributes: { user_id: @victor.to_param } } }

    assert_difference -> { @forum.memberships.blocked.count }, -1 do
      delete forum_blocked_member_url(@forum), params: params_data, headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end

  private

  def block_victor_at_first
    assert_difference -> { @forum.memberships.blocked.count } do
      Forums::BlockedMembership.create(forum: @forum, user: @victor)
    end
  end
end
