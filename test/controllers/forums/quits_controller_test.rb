require 'test_helper'

class Forums::QuitsControllerTest < ActionController::TestCase
  test '合法数据需正确持久化' do
    user_one = users(:victor)
    forum_one = forums(:one)
    @controller.instance_variable_set :@current_user, users(:victor)
    Forums::Join.create(forum_id: forum_one.id, user_id: user_one.id)
    assert_difference 'Forums::Enrollment.count', -1 do
      post :create, params: { forum_id: forums(:one).id }
      assert_response :success
    end
  end
end
