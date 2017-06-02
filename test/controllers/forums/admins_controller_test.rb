require 'test_helper'

class Forums::AdminsControllerTest < ActionDispatch::IntegrationTest
  test '将成员设置为管理员' do
    forum = forums(:one)
    current_user.add_role :owner, forum
    member = forum.members.first
    assert_empty member.reload.roles
    post forum_member_admin_url(forum_id: forum.id, member_id: member.id), headers: @headers
    assert member.reload.has_role? :admin, forum
  end

  test '将成员取消掉管理员' do
    forum = forums(:one)
    current_user.add_role :owner, forum
    member = forum.members.first
    assert_empty member.reload.roles
    post forum_member_admin_url(forum_id: forum.id, member_id: member.id), headers: @headers
    assert member.reload.has_role? :admin, forum

    delete forum_member_admin_url(forum_id: forum.id, member_id: member.id), headers: @headers
    assert_empty member.reload.roles
  end
end
