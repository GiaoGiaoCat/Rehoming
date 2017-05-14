require 'test_helper'

class Posts::FavoritesControllerTest < ActionController::TestCase
  def setup
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
    @victor.favor @post_one
  end

  test '用户收藏了一个主题' do
    post :create, params: { post_id: @post_two.id }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 2, @victor.favorites.count
  end

  test '用户不能重复收藏同一个主题' do
    post :create, params: { post_id: @post_one.to_param }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.favorites.count
  end
end
