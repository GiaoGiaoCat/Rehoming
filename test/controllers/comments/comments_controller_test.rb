require 'test_helper'

class Comments::CommentsControllerTest < ActionController::TestCase
  def setup
    @comment = comments(:one)
  end

  test 'can comment a comment' do
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

  test 'comment can attachable' do
    post :create, params: {
      comment_id: @comment.to_param,
      data: {
        type: 'comments',
        attributes: {
          content: '合法数据',
          attachments_attributes: [{
            category: 'image',
            url: 'http://www.baidu.com/hello.jpg'
          }]
        }
      }
    }
    assert_response :success
    assert_equal 201, @response.status
    assert_equal 1, @comment.comments.count
    assert_equal 1, @comment.comments.first.attachments.count
    assert_equal 'image', @comment.comments.first.attachments.first.category
  end
end
