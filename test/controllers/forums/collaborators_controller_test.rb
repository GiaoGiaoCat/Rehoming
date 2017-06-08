require 'test_helper'

class Forums::CollaboratorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
    @victor = users(:victor)
    @roc = users(:roc)
  end

  test '通过邀请码成为嘉宾' do
    invitation = forums_invitations(:one)
    params_data = { data: { attributes: { invitation_token: invitation.token } } }
    headers = { 'HTTP_AUTHORIZATION' => JsonWebToken.issue(user_id: @roc.id) }

    assert_difference -> { Forums::Membership.where(status: 'active').count } do
      post forum_collaborators_url(forums(:one)), params: params_data, headers: headers
    end
    assert_response :success
  end

  test '管理员删除一个用户的嘉宾身份' do
    @victor.add_role :moderator, @forum
    @roc.join_forum(@forum)
    @roc.add_role :collaborator, @forum

    assert_difference -> { @roc.roles.reload.count }, -1 do
      delete forum_collaborator_url(forums(:one), @roc), headers: @headers
    end
    assert_response :success
  end
end
