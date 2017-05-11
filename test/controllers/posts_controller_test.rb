require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @group = groups(:one)
  end

  test '合法数据需正确持久化' do
    post :create, params: {
      data: {
        type: 'posts',
        attributes: { group_id: @group.id, content: '合法数据' }
      }
    }
    assert_response :success
  end

  test '带标签的数据需正确持久化' do
    post :create, params: {
      data: {
        type: 'posts',
        attributes: { group_id: @group.id, content: '#我是标签# 合法数据' }
      }
    }
    assert_response :success
  end

  test '带 emoji 的数据需正确持久化' do
    post :create, params: {
      data: {
        type: 'posts',
        attributes: { group_id: @group.id, content: '👍合法数据' }
      }
    }
    assert_response :success
  end


  test '带附件的合法数据需正确持久化' do
    post :create, params: {
      data: {
        type: 'posts',
        attributes: {
          group_id: @group.id,
          content: '合法数据',
          attachments_attributes: [
            { category: 'image', url: '我是url' }
          ]
        }
      }
    }
    assert_response :success
  end

  test '内容过短，则不能持久化' do
    post :create, params: {
      data: {
        type: 'posts',
        attributes: { group_id: @group.id, content: '' }
      }
    }
    assert_response :bad_request
  end

  test '内容过长，则不能持久化' do
    post :create, params: {
      data: {
        type: 'posts',
        attributes: { group_id: @group.id, content: '1' * 10_001 }
      }
    }
    assert_response :bad_request
  end
end
