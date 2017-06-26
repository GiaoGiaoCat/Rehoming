require 'test_helper'

class Users::FavoritesControllerTest < ActionDispatch::IntegrationTest
  test '我的收藏列表' do
    get favorites_url, headers: @headers
    assert_response :success
  end
end
