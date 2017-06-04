require 'test_helper'

class ForumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
  end

  test 'should get show' do
    get forum_url(@forum), headers: @headers
    assert_response :success
  end

  test '用户创建圈子后，自动成为圈主' do
    assert_difference 'Forum.count' do
      params = { data: { attributes: { name: 'Forum one', category: 'wenyi' } } }
      post forums_url, headers: @headers, params: params
      assert current_user.has_role? :owner, Forum.last
    end
  end
end
