require 'test_helper'

class Comments::CommentsControllerTest < ActionController::TestCase
  def setup
    @comment = comments(:one)
  end

  test '可以对 comment 进行回复' do
    post :create, params: {
      comment_id: @comment.to_param,
      data: {
        type: 'comments',
        attributes: { content: '合法数据' }
      }
    }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @comment.comments.count
  end
end
