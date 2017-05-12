require 'test_helper'

class Comments::DislikesControllerTest < ActionController::TestCase
  def setup
    @victor = users(:victor)
    @comment_one = comments(:one)
    @comment_two = comments(:two)
    @victor.like @comment_one
  end

  test '用户取消赞了一个主题' do
    post :create, params: { comment_id: @comment_two.id }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.likes.count
  end

  test '没有赞过的主题也可以取消赞' do
    post :create, params: { comment_id: @comment_two.to_param }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.likes.count
  end

  test '用户可以重复取消赞同一个主题' do
    assert_difference '@victor.likes.count' do
      @victor.like @comment_two
    end

    assert_difference '@victor.likes.count', -1 do
      @victor.dislike @comment_two
    end

    post :create, params: { comment_id: @comment_two.to_param }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.likes.count
  end
end
