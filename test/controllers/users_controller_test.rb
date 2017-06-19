require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get current user' do
    get me_users_url, headers: @headers
    assert_response :success
  end

  test 'should update current user profile' do
    assert_changes -> { current_user.reload.nickname } do
      params = { data: { attributes: { nickname: 'Forum one' } } }
      patch me_users_url, params: params, headers: @headers
    end
    assert_response :success
  end
end
