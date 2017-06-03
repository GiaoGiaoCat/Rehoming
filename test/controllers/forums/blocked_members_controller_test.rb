require 'test_helper'

class Forums::BlockedMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
    @victor = users(:victor)
  end

  test '圈主、管理员才能查看拉黑成员列表' do
    # 无角色不能查看
    assert_empty current_user.roles
    get forum_blocked_members_url(forum_id: @forum.id), headers: @headers
    assert_response 403

    # 圈主可查看
    current_user.add_role :owner, @forum
    get forum_blocked_members_url(forum_id: @forum.id), headers: @headers
    assert_response 200
    current_user.remove_role :owner, @forum
    assert_empty current_user.roles

    # 管理员可查看
    current_user.add_role :admin, @forum
    get forum_blocked_members_url(forum_id: @forum.id), headers: @headers
    assert_response 200
    current_user.remove_role :admin, @forum
    assert_empty current_user.roles

    # 嘉宾不可查看
    current_user.add_role :collaborator, @forum
    get forum_blocked_members_url(forum_id: @forum.id), headers: @headers
    assert_response 403
    current_user.remove_role :collaborator, @forum
    assert_empty current_user.roles

    # 普通成员不可查看
    current_user.add_role :member, @forum
    get forum_blocked_members_url(forum_id: @forum.id), headers: @headers
    assert_response 403
    current_user.remove_role :member, @forum
    assert_empty current_user.roles
  end

  test '只有圈主、管理员才能拉黑成员' do
    params_data = { data: { attributes: { user_id: @victor.to_param } } }

    # 无角色不能操作
    assert_empty current_user.roles
    assert_no_difference -> { @forum.memberships.blocked.count } do
      post forum_blocked_members_url(forum_id: @forum.id), params: params_data, headers: @headers
      assert_response 403
    end

    # 圈主可操作
    current_user.add_role :owner, @forum
    assert_difference -> { @forum.memberships.blocked.count } do
      post forum_blocked_members_url(forum_id: @forum.id), params: params_data, headers: @headers
      assert_response :no_content
    end
    @forum.memberships.each { |m| m.update(status: 40) } # 恢复状态
    current_user.remove_role :owner, @forum
    assert_empty current_user.roles

    # 管理员可操作
    current_user.add_role :admin, @forum
    assert_difference -> { @forum.memberships.blocked.count } do
      post forum_blocked_members_url(forum_id: @forum.id), params: params_data, headers: @headers
      assert_response :no_content
    end
    @forum.memberships.each { |m| m.update(status: 40) } # 恢复状态
    current_user.remove_role :admin, @forum
    assert_empty current_user.roles

    # 嘉宾不可操作
    current_user.add_role :collaborator, @forum
    assert_no_difference -> { @forum.memberships.blocked.count } do
      post forum_blocked_members_url(forum_id: @forum.id), params: params_data, headers: @headers
      assert_response 403
    end
    current_user.remove_role :collaborator, @forum
    assert_empty current_user.roles

    # 普通成员不可操作
    current_user.add_role :member, @forum
    assert_no_difference -> { @forum.memberships.blocked.count } do
      post forum_blocked_members_url(forum_id: @forum.id), params: params_data, headers: @headers
      assert_response 403
    end
    current_user.remove_role :member, @forum
    assert_empty current_user.roles
  end

  test '只有圈主、管理员才能取消拉黑成员' do
    block_victor_at_first

    params_data = { data: { attributes: { user_id: @victor.to_param } } }

    # 无角色不能操作
    assert_empty current_user.roles
    assert_no_difference -> { @forum.memberships.blocked.count }, -1 do
      delete forum_blocked_member_url(forum_id: @forum.id, id: @victor.id), params: params_data, headers: @headers
      assert_response 403
    end

    # 嘉宾不可操作
    current_user.add_role :collaborator, @forum
    assert_no_difference -> { @forum.memberships.blocked.count } do
      delete forum_blocked_member_url(forum_id: @forum.id, id: @victor.id), params: params_data, headers: @headers
      assert_response 403
    end
    current_user.remove_role :collaborator, @forum
    assert_empty current_user.roles

    # 普通成员不可操作
    current_user.add_role :member, @forum
    assert_no_difference -> { @forum.memberships.blocked.count } do
      delete forum_blocked_member_url(forum_id: @forum.id, id: @victor.id), params: params_data, headers: @headers
      assert_response 403
    end
    current_user.remove_role :member, @forum
    assert_empty current_user.roles

    # 圈主可操作
    current_user.add_role :owner, @forum
    assert_difference -> { @forum.memberships.blocked.count }, -1 do
      delete forum_blocked_member_url(forum_id: @forum.id, id: @victor.id), params: params_data, headers: @headers
      assert_response :no_content
    end
    current_user.remove_role :owner, @forum
    assert_empty current_user.roles

    # 管理员可操作
    block_victor_at_first
    current_user.add_role :admin, @forum
    assert_difference -> { @forum.memberships.blocked.count }, -1 do
      delete forum_blocked_member_url(forum_id: @forum.id, id: @victor.id), params: params_data, headers: @headers
      assert_response :no_content
    end
    current_user.remove_role :admin, @forum
    assert_empty current_user.roles
  end

  private

  def block_victor_at_first
    assert_difference -> { @forum.memberships.blocked.count } do
      Forums::BlockedMembership.create(forum: @forum, user: @victor)
    end
  end
end
