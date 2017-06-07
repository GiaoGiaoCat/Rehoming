require 'test_helper'

class Forums::AdminsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
  end

  test '只有圈主能修改管理员' do
    member = @forum.members.first
    assert_empty member.reload.roles

    assert_no_difference -> { member.roles.reload.count } do
      post forum_admins_url(forum_id: @forum.id, id: member.id), headers: @headers
    end
  end

  test '将成员设置为管理员' do
    current_user.add_role :moderator, @forum
    member = @forum.members.first
    assert_empty member.reload.roles

    post forum_admins_url(forum_id: @forum.id, id: member.id), headers: @headers
    assert member.reload.has_role? :admin, @forum
  end

  test '将成员取消掉管理员' do
    current_user.add_role :moderator, @forum
    member = @forum.members.first
    assert_empty member.reload.roles
    member.add_role :admin, @forum

    delete forum_admin_url(forum_id: @forum.id, id: member.id), headers: @headers
    assert_empty member.reload.roles
  end
end
