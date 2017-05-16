require 'test_helper'

class Groups::RenamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @group = groups(:one)
    @enrollment = Groups::Join.create(group_id: @group.id, user_id: @victor.id)
  end

  test 'should create rename' do
    params_data = {
      data: { attributes: { name: 'new nickname' } }
    }
    assert_changes -> { @victor.group_enrollments.find_by(group_id: @group.id).nickname } do
      post group_rename_url(@group), params: params_data, headers: @headers
    end
    assert_response :success
    assert_equal 201, @response.status
  end
end
