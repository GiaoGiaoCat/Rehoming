require 'test_helper'

class Comments::LikesControllerTest < ActionController::TestCase
  def setup
    @victor = users(:victor)
    @comment_one = comments(:one)
    @comment_two = comments(:two)
    @victor.like @comment_one
  end

  test '用户赞了一个回复' do
    post :create, params: { comment_id: @comment_two.id }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 2, @victor.likes.count
  end

  test '用户不能重复赞同一个回复' do
    post :create, params: { comment_id: @comment_one.to_param }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.likes.count
  end
end
