require 'test_helper'

class Forums::MembershipRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:two)
    @roc = users(:roc)
  end

  test 'should get index' do
    get forum_membership_requests_url(@forum), headers: @headers
    assert_response :success
  end

  test 'should create membership request' do
    assert_difference -> { Forums::MembershipRequest.count } do
      post forum_membership_requests_url(@forum), headers: @headers
    end
    assert_response :success
  end

  test '只有圈主能审批加圈申请' do
    @roc.join_forum(@forum)
    membership_request = @forum.membership_requests.find_by(user: @roc)
    params_data = { data: { attributes: { action: 'accept' } } }

    assert_raises Pundit::NotAuthorizedError do
      put forum_membership_request_url(@forum, membership_request), params: params_data, headers: @headers
    end

    current_user.add_role :owner, @forum
    assert_difference -> { Forums::Membership.active.count } do
      put forum_membership_request_url(@forum, membership_request), params: params_data, headers: @headers
      assert_response :success
    end
  end
end
