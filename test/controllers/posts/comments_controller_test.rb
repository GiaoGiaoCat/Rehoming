require 'test_helper'

class Posts::CommentsControllerTest < ActionController::TestCase
  def setup
    @post = posts(:one)
  end

  test '可以对 post 进行回复' do
    post :create, params: {
      post_id: @post.to_param,
      data: {
        type: 'comments',
        attributes: { content: '合法数据' }
      }
    }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @post.comments.count
  end
end
