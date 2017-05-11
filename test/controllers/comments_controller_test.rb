require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test '可以对 post 进行回复' do
    post :create, params: {
      post_id: posts(:one).id,
      content: '111'
    }
    assert_response :success
  end

  test '可以对 comment 进行回复' do
    post :create, params: {
      comment_id: comments(:one).id,
      content:    '222'
    }
    assert_response :success
  end
end
