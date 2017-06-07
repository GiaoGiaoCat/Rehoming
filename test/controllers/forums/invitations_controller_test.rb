require 'test_helper'

class Forums::InvitationsControllerTest < ActionDispatch::IntegrationTest
  test '只有圈主才能生成邀请码' do
    forum = forums(:one)

    post forum_invitations_url(forum_id: forum.id), headers: @headers
    assert_response :forbidden

    assert_difference 'Forums::Invitation.where(forum: forum).count' do
      current_user.add_role :moderator, forum
      post forum_invitations_url(forum_id: forum.id), headers: @headers
      assert_response :created
    end
  end
end
