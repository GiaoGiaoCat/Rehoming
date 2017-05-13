require 'test_helper'

class Posts::CommentsControllerTest < ActionController::TestCase
  def setup
    @post = posts(:one)
  end

  test 'can comment a post' do
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

  test 'comment can attachable' do
    post :create, params: {
      post_id: @post.to_param,
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
    assert_equal 1, @post.comments.count
    assert_equal 1, @post.comments.first.attachments.count
    assert_equal 'image', @post.comments.first.attachments.first.category
  end
end
