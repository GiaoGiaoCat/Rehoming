require 'test_helper'

class Forums::MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
    @victor = users(:victor)
    @yuki = users(:yuki)
  end

  test 'should get index' do
    get forum_members_url(forums(:one)), headers: @headers
    assert_response :success
  end

  test "only forum's owner and admin can destroy member" do
    # 圈主可操作
    setup_role(:owner) do
      assert_difference -> { @forum.members.count }, -1 do
        delete forum_member_url(@forum, @yuki), headers: @headers
      end
    end

    # 管理员可操作
    @yuki.join_forum(@forum)
    setup_role(:admin) do
      assert_difference -> { @forum.members.count }, -1 do
        delete forum_member_url(@forum, @yuki), headers: @headers
      end
    end

    # 嘉宾不可操作
    @yuki.join_forum(@forum)
    setup_role(:collaborator) do
      assert_no_difference -> { @forum.members.count } { delete forum_member_url(@forum, @yuki), headers: @headers }
    end

    # 普通成员不可操作
    @yuki.join_forum(@forum)
    setup_role(:member) do
      assert_no_difference -> { @forum.members.count } { delete forum_member_url(@forum, @yuki), headers: @headers }
    end
  end
end
