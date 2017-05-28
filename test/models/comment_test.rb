require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @victor = users(:victor)
    @post = posts(:one)
    @comment = comments(:one)
    @new_comment = Comment.new(commentable: @post, user: @victor)
  end

  test '验证必填项' do
    f = Comment.new
    assert_not f.valid?
    assert f.errors.key? :user
    assert f.errors.key? :content
    assert f.errors.key? :commentable
  end

  test '携带附件时评论内容可以为空' do
    @new_comment.attachments.new(url: 'http://www.baidu.com/hello.jpg', category: 10)
    assert @new_comment.valid?
    assert @new_comment.save
  end

  test '携带附件数量不能超过1个' do
    @new_comment.attachments.new(url: 'http://www.baidu.com/hello.jpg', category: 10)
    @new_comment.attachments.new(url: 'http://www.baidu.com/yeah.jpg', category: 10)
    assert_not @new_comment.valid?
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

  test 'ensure_forum' do
    @new_comment.attachments.new(url: 'http://www.baidu.com/hello.jpg', category: 10)
    assert @new_comment.save
    assert_equal @post.forum, @new_comment.forum
  end
end
