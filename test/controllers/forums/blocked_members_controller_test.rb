require 'test_helper'

class Forums::BlockedMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
    @victor = users(:victor)
    @params_data = { data: { attributes: { user_id: @victor.to_param } } }
  end

  test '圈主、管理员才能查看拉黑成员列表' do
    # 无角色不能查看
    assert_empty current_user.roles
    get_forum_blocked_members(:forbidden)
    # 圈主可查看
    setup_role(:owner) { get_forum_blocked_members(:ok) }
    # 管理员可查看
    setup_role(:admin) { get_forum_blocked_members(:ok) }
    # 嘉宾不可查看
    setup_role(:collaborator) { get_forum_blocked_members(:forbidden) }
    # 普通成员不可查看
    setup_role(:member) { get_forum_blocked_members(:forbidden) }
  end

  test '只有圈主、管理员才能拉黑成员' do
    # 无角色不能操作
    assert_empty current_user.roles
    assert_blocked_members_no_difference(:post, :forbidden)

    # 圈主可操作
    setup_role(:owner) do
      assert_blocked_members_difference(:post, :created, 1)
      @forum.memberships.each { |m| m.update(status: 40) } # 恢复状态
    end

    # 管理员可操作
    setup_role(:admin) do
      assert_blocked_members_difference(:post, :created, 1)
      @forum.memberships.each { |m| m.update(status: 40) } # 恢复状态
    end

    # 嘉宾不可操作
    assert_blocked_members(action: :post, role: :collaborator, difference: false)

    # 普通成员不可操作
    assert_blocked_members(action: :post, role: :member, difference: false)
  end

  test '只有圈主、管理员才能取消拉黑成员' do
    block_victor_at_first

    # 无角色不能操作
    assert_empty current_user.roles
    assert_blocked_members_no_difference(:delete, :forbidden)

    # 嘉宾不可操作
    assert_blocked_members(action: :delete, role: :collaborator, difference: false)

    # 普通成员不可操作
    assert_blocked_members(action: :delete, role: :member, difference: false)

    # 圈主可操作
    assert_blocked_members(action: :delete, role: :owner, difference: true, step: -1)

    # 管理员可操作
    block_victor_at_first
    assert_blocked_members(action: :delete, role: :admin, difference: true, step: -1)
  end

  private

  def block_victor_at_first
    assert_difference -> { @forum.memberships.blocked.count } do
      Forums::BlockedMembership.create(forum: @forum, user: @victor)
    end
  end

  def setup_role(role)
    current_user.add_role role, @forum
    yield
    current_user.remove_role role, @forum
    assert_empty current_user.roles
  end

  def assert_blocked_members(action:, role:, difference: true, step: 1)
    setup_role(role) do
      if difference
        assert_blocked_members_difference(action, :no_content, step)
      else
        assert_blocked_members_no_difference(action, :forbidden)
      end
    end
  end

  def assert_blocked_members_difference(action, status_code, step)
    assert_difference -> { @forum.memberships.blocked.count }, step do
      case action
      when :delete then delete_forum_blocked_member(status_code)
      when :post then post_forum_blocked_member(status_code)
      end
    end
  end

  def assert_blocked_members_no_difference(action, status_code)
    assert_no_difference -> { @forum.memberships.blocked.count } do
      case action
      when :delete then delete_forum_blocked_member(status_code)
      when :post then post_forum_blocked_member(status_code)
      end
    end
  end

  def get_forum_blocked_members(status_code)
    get forum_blocked_members_url(forum_id: @forum.id), headers: @headers
    assert_response status_code
  end

  def delete_forum_blocked_member(status_code)
    delete forum_blocked_member_url(forum_id: @forum.id, id: @victor.id), params: @params_data, headers: @headers
    assert_response status_code
  end

  def post_forum_blocked_member(status_code)
    post forum_blocked_members_url(forum_id: @forum.id), params: @params_data, headers: @headers
    assert_response status_code
  end
end
