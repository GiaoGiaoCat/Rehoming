require 'test_helper'

class Posts::DislikesControllerTest < ActionController::TestCase
  def setup
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
    @victor.like @post_one
  end

  test '用户取消赞了一个主题' do
    post :create, params: { post_id: @post_one.id }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 0, @victor.likes.count
  end

  test '没有赞过的主题也可以取消赞' do
    post :create, params: { post_id: @post_two.to_param }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.likes.count
  end

  test '用户可以重复取消赞同一个主题' do
    assert_difference '@victor.likes.count' do
      @victor.like @post_two
    end

    assert_difference '@victor.likes.count', -1 do
      @victor.dislike @post_two
    end

    post :create, params: { post_id: @post_two.to_param }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.likes.count
  end
end
