require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  test '合法数据需正确持久化' do
    post :create, params: { post: { content: '合法数据' } }
    assert_response :success
  end

  test '带附件的合法数据需正确持久化' do
    post :create, params: {
      post: {
        content: '合法数据',
        attachments_attributes: [
          { category: 'image', url: '我是url' }
        ]
      }
    }
    assert_response :success
  end

  test '内容过短，则不能持久化' do
    post :create, params: { post: { content: '' } }
    assert_response :bad_request
  end

  test '内容过长，则不能持久化' do
    post :create, params: { post: { content: '1' * 10_001 } }
    assert_response :bad_request
  end
end
