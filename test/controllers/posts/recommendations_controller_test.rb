require 'test_helper'

class Posts::RecommendationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
    @forum = @post_one.forum
  end

  test '圈主才能设置精华帖' do
    setup_role(:owner, @forum) { assert_recommendeds_difference(:post, :created, 1) }
  end

  test '管理员能设置精华帖' do
    setup_role(:admin, @forum) { assert_recommendeds_difference(:post, :created, 1) }
  end

  test '圈主才能取消精华帖' do
    setup_role(:owner, @forum) { assert_recommendeds_difference(:delete, :no_content, -1) }
  end

  test '管理员能取消精华帖' do
    setup_role(:admin, @forum) { assert_recommendeds_difference(:delete, :no_content, -1) }
  end

  test '其它角色不能设置或取消精华帖' do
    # 无角色不能操作
    assert_empty current_user.roles
    assert_recommendeds_no_difference(:post, :forbidden)
    assert_recommendeds_no_difference(:delete, :forbidden)

    # 嘉宾不可操作
    setup_role(:collaborator, @forum) { assert_recommendeds_no_difference(:post, :forbidden) }
    setup_role(:collaborator, @forum) { assert_recommendeds_no_difference(:delete, :forbidden) }

    # 普通成员不可操作
    setup_role(:member, @forum) { assert_recommendeds_no_difference(:post, :forbidden) }
    setup_role(:member, @forum) { assert_recommendeds_no_difference(:delete, :forbidden) }
  end

  private

  def assert_recommendeds_difference(action, status_code, step)
    assert_difference -> { Post.by_recommended.count }, step do
      assert_status_code_after_run_action(action, status_code)
    end
  end

  def assert_recommendeds_no_difference(action, status_code)
    assert_no_difference -> { Post.by_recommended.count } do
      assert_status_code_after_run_action(action, status_code)
    end
  end

  def assert_status_code_after_run_action(action, status_code)
    case action
    when :delete then delete_recommend(status_code)
    when :post then post_recommend(status_code)
    end
  end

  def post_recommend(status_code)
    post post_recommendation_url(@post_two), headers: @headers
    assert_response status_code
  end

  def delete_recommend(status_code)
    delete post_recommendation_url(@post_one), headers: @headers
    assert_response status_code
  end
end
