require 'test_helper'

class Groups::RenamesControllerTest < ActionController::TestCase
  def setup
    @victor = users(:victor)
    @group_one = groups(:one)
    @enrollment = Groups::Join.create(group_id: @group_one.id, user_id: @victor.id)
  end

  test '合法数据需正确持久化' do
    Groups::Join.create(group_id: @group_one.id, user_id: @victor.id)
    post :create, params: { group_id: @group_one.id, name: '我是新昵称' }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal '我是新昵称', @victor.group_enrollments.find_by(group: @group_one).nickname
  end
end
