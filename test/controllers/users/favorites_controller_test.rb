require 'test_helper'

class Users::FavoritesControllerTest < ActionDispatch::IntegrationTest
  test '我的收藏列表' do
    get user_favorites_url(users(:victor)), headers: @headers
    assert_response :success
  end
end
