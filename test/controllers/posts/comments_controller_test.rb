require 'test_helper'

class Posts::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:post_with_no_comment)
    @comment = comments(:three)
  end

  test 'create a comment to post' do
    params_data = { data: { attributes: { content: '合法数据' } } }
    assert_difference -> { @post.comments.count } do
      post post_comments_url(@post), params: params_data, headers: @headers
    end

    assert_response :success
    assert_equal 201, @response.status
  end

  test 'comment with replyer' do
    params_data = {
      data: {
        attributes: { content: '合法数据', replied_user_id: @comment.author.id }
      }
    }
    assert_difference -> { @post.comments.count } do
      post post_comments_url(@post), params: params_data, headers: @headers
    end

    assert_response :success
    assert_equal @comment.author.id, @post.comments.last.replied_user_id
  end

  test 'create a comment with attachments' do
    params_data = {
      data: {
        attributes: {
          content: '合法数据',
          attachments_attributes: [{ category: 'image', url: 'http://www.baidu.com/hello.jpg' }]
        }
      }
    }
    assert_difference -> { @post.comments.count } do
      post post_comments_url(@post), params: params_data, headers: @headers
    end

    assert_response :success
    assert_not @post.comments.first.attachments.count.zero?
    assert_equal 'image', @post.comments.first.attachments.first.category
  end
end
