require 'test_helper'

class Users::PostsControllerTest < ActionController::TestCase
  setup do
    @group = groups(:one)
  end

  test '我的帖子列表' do
    get :index, params: { user_id: users(:victor).id }
    assert_response :success
  end
end
