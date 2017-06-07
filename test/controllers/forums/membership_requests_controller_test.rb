require 'test_helper'

class Forums::MembershipRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:two)
    @roc = users(:roc)
  end

  test "only forum's moderator can get index" do
    get forum_membership_requests_url(@forum), headers: @headers
    assert_response :forbidden

    users(:victor).add_role :moderator, @forum
    get forum_membership_requests_url(@forum), headers: @headers
    assert_response :success
  end

  test 'should create membership request' do
    headers = { 'HTTP_AUTHORIZATION' => JsonWebToken.issue(user_id: users(:roc).id) }

    assert_difference -> { Forums::MembershipRequest.count } do
      post forum_membership_requests_url(@forum), headers: headers
    end
    assert_response :success
  end

  test "only forum's moderator can examine and approve membership request" do
    @roc.join_forum(@forum)
    membership_request = @forum.membership_requests.find_by(user: @roc)
    params_data = { data: { attributes: { action: 'accept' } } }

    put forum_membership_request_url(@forum, membership_request), params: params_data, headers: @headers
    assert_response :forbidden

    current_user.add_role :moderator, @forum
    assert_difference -> { Forums::Membership.active.count } do
      put forum_membership_request_url(@forum, membership_request), params: params_data, headers: @headers
      assert_response :success
    end
  end
end
