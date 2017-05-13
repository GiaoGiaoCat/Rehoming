require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @victor = users(:victor)
    @post = posts(:one)
    @comment = comments(:one)
  end

  test '验证必填项' do
    f = Comment.new
    assert_not f.valid?
    assert f.errors.key? :user
    assert f.errors.key? :content
    assert f.errors.key? :commentable
  end

  test '可以对 post 进行回复' do
    assert_difference '@post.comments.count' do
      f = Comment.new(
        commentable: @post,
        user:        @victor,
        content:     'comment goes here'
      )
      assert f.valid?
      assert f.save
    end
  end

  test '可以对 comment 进行回复' do
    assert_difference '@comment.comments.count' do
      f = Comment.new(
        commentable: @comment,
        user:        @victor,
        content:     'content'
      )
      assert f.valid?
      assert f.save
    end
  end
end
