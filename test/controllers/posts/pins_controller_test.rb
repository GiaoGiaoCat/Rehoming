require 'test_helper'

class Posts::PinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @post_pined = posts(:one)
    @post_unpined = posts(:two)
    @forum = @post_pined.forum
  end

  test '圈主才能设置置顶' do
    setup_role(:moderator, @forum) do
      assert_changes -> { @post_pined.reload.sticky } do
        assert_pins_no_difference(:post, :no_content)
      end
    end
  end

  test '管理员能设置置顶' do
    setup_role(:admin, @forum) do
      assert_changes -> { @post_pined.reload.sticky } do
        assert_pins_no_difference(:post, :no_content)
      end
    end
  end

  test '圈主才能取消置顶' do
    setup_role(:moderator, @forum) { assert_pins_difference(:delete, :no_content, -1) }
  end

  test '管理员能取消置顶' do
    setup_role(:admin, @forum) { assert_pins_difference(:delete, :no_content, -1) }
  end

  test '其它角色不能置顶或取消置顶' do
    # 无角色不能操作
    assert_empty current_user.roles
    assert_pins_no_difference(:post, :forbidden)
    assert_pins_no_difference(:delete, :forbidden)

    # 嘉宾不可操作
    setup_role(:collaborator, @forum) { assert_pins_no_difference(:delete, :forbidden) }
    setup_role(:collaborator, @forum) { assert_pins_no_difference(:post, :forbidden) }

    # 普通成员不可操作
    setup_role(:member, @forum) { assert_pins_no_difference(:delete, :forbidden) }
    setup_role(:member, @forum) { assert_pins_no_difference(:post, :forbidden) }
  end

  private

  def assert_pins_difference(action, status_code, step)
    assert_difference -> { Post.by_pinned.count }, step do
      assert_status_code_after_run_action(action, status_code)
    end
  end

  def assert_pins_no_difference(action, status_code)
    assert_no_difference -> { Post.by_pinned.count } do
      assert_status_code_after_run_action(action, status_code)
    end
  end

  def assert_status_code_after_run_action(action, status_code)
    case action
    when :delete then delete_pin(status_code)
    when :post then post_pin(status_code)
    end
  end

  def post_pin(status_code)
    post post_pin_url(@post_unpined), headers: @headers
    assert_response status_code
  end

  def delete_pin(status_code)
    delete post_pin_url(@post_pined), headers: @headers
    assert_response status_code
  end
end
