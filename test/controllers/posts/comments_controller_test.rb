require 'test_helper'

class Posts::CommentsControllerTest < ActionController::TestCase
  def setup
    @post = posts(:post_with_no_comment)
  end

  test '可以对 post 发表评论' do
    assert_difference '@post.comments.count' do
      post :create, params: {
        post_id: @post.to_param,
        data: {
          type: 'comments',
          attributes: { content: '合法数据' }
        }
      }
      assert_response :success
      assert_equal 201, @response.status
    end
  end

  test '可以对 post 的评论者进行回复' do
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

    @headers = { 'HTTP_AUTHORIZATION' => JsonWebToken.issue(user_id: users(:yuki).id) }

    post :create, params: {
      post_id: @post.to_param,
      data: {
        type: 'comments',
        attributes: { content: '真是合法数据吗？', replied_user_id: users(:victor).id }
      }
    }

    assert_response :success
    assert_equal 201, @response.status
    assert_equal 2, @post.comments.count
    assert_equal users(:victor).id, @post.comments.last.replied_user_id
  end

  test '评论可以带附件' do
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
