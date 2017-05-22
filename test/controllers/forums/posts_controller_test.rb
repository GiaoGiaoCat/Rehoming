require 'test_helper'

class Forums::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
  end

  test 'should get index' do
    get forum_posts_url(@forum), headers: @headers
    assert_response :success
  end

  test 'should create post' do
    assert_difference('Post.count') do
      post forum_posts_url(@forum), params: { data: { attributes: { content: '合法数据' } } }, headers: @headers
    end

    assert_response :success
  end

  test 'should create post with attachments' do
    params_data = {
      data: {
        attributes: {
          content: '#我是标签# 合法数据',
          attachments_attributes: [{ category: 'image', url: '我是url' }]
        }
      }
    }
    assert_difference('Post.count') do
      post forum_posts_url(@forum), params: params_data, headers: @headers
    end

    assert_response :success
  end
end
