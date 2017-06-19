require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get current user' do
    get me_users_url, headers: @headers
    assert_response :success
  end

  test 'should update current user profile and refresh cache' do
    assert_changes -> { Rails.cache.read(current_user.to_param) } do
      assert_changes -> { current_user.reload.nickname } do
        params = { data: { attributes: { nickname: 'Forum one' } } }
        patch me_users_url, params: params, headers: @headers
      end
    end
    assert_response :success
  end
end
