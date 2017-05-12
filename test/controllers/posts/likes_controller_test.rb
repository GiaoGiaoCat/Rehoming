require 'test_helper'

class Posts::LikesControllerTest < ActionController::TestCase
  def setup
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
    @victor.like @post_one
  end

  test '用户赞了一个主题' do
    post :create, params: { post_id: @post_two.id }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 2, @victor.likes.count
  end

  test '用户不能重复赞同一个主题' do
    post :create, params: { post_id: @post_one.to_param }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @victor.likes.count
  end
end
