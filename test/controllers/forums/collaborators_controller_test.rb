require 'test_helper'

class Forums::CollaboratorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @forum = forums(:one)
  end

  test '通过邀请码成为嘉宾' do
    invitation = forums_invitations(:one)
    params_data = { data: { attributes: { invitation_token: invitation.token } } }
    headers = { 'HTTP_AUTHORIZATION' => JsonWebToken.issue(user_id: users(:roc).id) }

    assert_difference -> { Forums::Membership.where(status: 'active').count } do
      post forum_collaborators_url(forums(:one)), params: params_data, headers: headers
    end
    assert_response :success
  end
end
