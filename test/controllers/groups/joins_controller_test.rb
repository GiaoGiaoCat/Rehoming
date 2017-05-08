require 'test_helper'

class Groups::JoinsControllerTest < ActionController::TestCase
  test '合法数据需正确持久化' do
    assert_difference 'Groups::Enrollment.count', 1 do
      post :create, params: { group_id: groups(:one).id, user_id: users(:one).id }
      assert_response :success
    end
  end
end
