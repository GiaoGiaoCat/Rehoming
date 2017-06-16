require 'test_helper'

class Posts::CommentsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @post = posts(:post_with_no_comment)
    @comment = comments(:three)
    @roc = users(:roc)
  end

  test 'should create comment' do
    params_data = {
      data: {
        attributes: {
          content: '合法数据',
          replied_user_id: @comment.author.to_param,
          attachments_attributes: [{ category: 'image', url: 'http://www.baidu.com/hello.jpg' }]
        }
      }
    }
    assert_difference -> { @post.comments.count } do
      post post_comments_url(@post), params: params_data, headers: @headers
    end

    assert_response :success
    assert_equal 201, @response.status

    # comment with replyer
    assert_equal @comment.author.id, @post.comments.last.replied_user_id

    # comment with attachments
    assert_not @post.comments.first.attachments.count.zero?
    assert_equal 'image', @post.comments.first.attachments.first.category
  end

  test 'create comment should feed' do
    params_data = { data: { attributes: { content: '合法数据' } } }
    assert_difference -> { @comment.commentable.author.feeds.count } do
      perform_enqueued_jobs do
        post post_comments_url(@post), params: params_data, headers: @headers
      end
    end

    assert_performed_jobs 1
  end

  test 'create comment should not feed when post author is current user' do
    params_data = { data: { attributes: { content: '合法数据' } } }
    assert_no_difference -> { posts(:one).author.feeds.count } do
      assert_no_performed_jobs do
        post post_comments_url(posts(:one)), params: params_data, headers: @headers
      end
    end
  end

  test 'create comment to replyer should two feeds' do
    params_data = { data: { attributes: { content: '合法数据', replied_user_id: @roc.to_param } } }
    assert_difference -> { @roc.feeds.count } do
      assert_difference -> { @post.author.feeds.count } do
        perform_enqueued_jobs do
          post post_comments_url(@post), params: params_data, headers: @headers
        end
      end
    end

    assert_performed_jobs 2
  end

  test 'create comment to replyer should not feed to post author when post author is current user' do
    params_data = { data: { attributes: { content: '合法数据', replied_user_id: @roc.to_param } } }
    assert_difference -> { @roc.feeds.count } do
      assert_no_difference -> { posts(:one).author.feeds.count } do
        perform_enqueued_jobs do
          post post_comments_url(posts(:one)), params: params_data, headers: @headers
        end
      end
    end

    assert_performed_jobs 1
  end

  test 'create comment to replyer should not feed to replyer when post author is replyer' do
    params_data = { data: { attributes: { content: '合法数据', replied_user_id: users(:yuki).to_param } } }
    assert_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs do
        post post_comments_url(posts(:three)), params: params_data, headers: @headers
      end
    end

    assert_performed_jobs 1
  end
end
