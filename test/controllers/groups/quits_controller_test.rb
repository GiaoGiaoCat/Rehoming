require 'test_helper'

class Groups::QuitsControllerTest < ActionController::TestCase
  test '合法数据需正确持久化' do
    user_one = users(:victor)
    group_one = groups(:one)
    @controller.instance_variable_set :@current_user, users(:victor)
    Groups::Join.create(group_id: group_one.id, user_id: user_one.id)
    assert_difference 'Groups::Enrollment.count', -1 do
      post :create, params: { group_id: groups(:one).id }
      assert_response :success
    end
  end
end
