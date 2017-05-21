require 'test_helper'

class Forums::JoinsControllerTest < ActionController::TestCase
  test '合法数据需正确持久化' do
    assert_difference 'Forums::Enrollment.count', 1 do
      @controller.instance_variable_set :@current_user, users(:victor)
      post :create, params: { forum_id: forums(:one).id }
      assert_response :success
    end
  end
end
