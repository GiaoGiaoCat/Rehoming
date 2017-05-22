require 'test_helper'

class Forums::RenamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @forum = forums(:one)
    @enrollment = Forums::Join.create(forum_id: @forum.id, user_id: @victor.id)
  end

  test 'should create rename' do
    params_data = {
      data: { attributes: { name: 'new nickname' } }
    }
    assert_changes -> { @victor.forum_enrollments.find_by(forum_id: @forum.id).nickname } do
      post forum_rename_url(@forum), params: params_data, headers: @headers
    end
    assert_response :success
    assert_equal 201, @response.status
  end
end
