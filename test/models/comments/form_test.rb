require 'test_helper'

class Comments::FormTest < ActiveSupport::TestCase
  test '验证必填项' do
    f = Comments::Form.new
    assert_not f.valid?
    assert f.errors.key? :user
    assert f.errors.key? :content
    assert f.errors.key? :commentable
  end

  test '可以对 post 进行回复' do
    post_one = posts(:one)
    user_one = users(:victor)
    assert_difference 'post_one.comments.count', 1 do
      f = Comments::Form.new(
        post_id: post_one.id,
        user:    user_one,
        content: 'comment goes here'
      )
      assert f.valid?
      assert f.save
    end
  end

  test '可以对 comment 进行回复' do
    comment_one = comments(:one)
    assert_difference 'comment_one.comments.count', 1 do
      f = Comments::Form.new(
        comment_id: comment_one.id,
        user_id:    users(:victor).id,
        content:    'content'
      )
      assert f.valid?
      assert f.save
    end
  end
end
