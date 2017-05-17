require 'test_helper'

class Posts::PinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
    @victor.favor @post_one
  end

  test 'should create pin' do
    # post post_pin_url(@post_one), headers: @headers
    # # assert_changes -> { @victor.group_enrollments.find_by(group_id: @group.id).nickname } do
    # #   post group_rename_url(@group), params: params_data, headers: @headers
    # # end
    # assert_response :success
    # assert_equal 201, @response.status
  end
end
