require 'test_helper'

class Groups::RenamesControllerTest < ActionController::TestCase
  test '合法数据需正确持久化' do
    user_one = users(:victor)
    group_one = groups(:one)
    @controller.instance_variable_set :@current_user, users(:victor)
    Groups::Join.create(group_id: group_one.id, user_id: user_one.id)
    post :create, params: { group_id: groups(:one).id, name: '我是新昵称' }
    assert_response :success
    assert_equal '我是新昵称',
                 user_one.group_enrollments.find_by(group: group_one).nickname
  end
end
