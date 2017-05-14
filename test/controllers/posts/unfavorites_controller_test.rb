require 'test_helper'

class Posts::UnfavoritesControllerTest < ActionController::TestCase
  def setup
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
    @victor.favor @post_one
  end

  test '用户取消收藏了一个主题' do
    post :create, params: { post_id: @post_one.id }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 0, @victor.favorites.count
  end

  test '没有收藏过的主题也可以取收藏' do
    post :create, params: { post_id: @post_two.to_param }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.favorites.count
  end

  test '用户可以重复取消收藏同一个主题' do
    assert_difference '@victor.favorites.count' do
      @victor.favor @post_two
    end

    assert_difference '@victor.favorites.count', -1 do
      @victor.unfavor @post_two
    end

    post :create, params: { post_id: @post_two.to_param }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.favorites.count
  end
end
