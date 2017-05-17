require 'test_helper'

class ActsAsPinableTest < ActiveSupport::TestCase
  def setup
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
    @comment = comments(:one)
  end

  test '验证 pinable? 方法正确' do
    assert @post_one.pinable?
    assert_raises NoMethodError do
      @victor.pinable?
    end
  end

  test '用户可以置顶帖子和取消置顶' do
    assert_difference 'Post.where(sticky: true).count' do
      @victor.pin @post_two
    end

    @victor.pin @post_one
    assert_difference 'Post.where(sticky: true).count', -1 do
      @victor.unpin @post_one
    end
  end

  test '不能重复赞同一个帖子或评论' do
    @victor.like @post_one
    assert_difference '@victor.likes.count', 0 do
      @victor.like @post_one
    end
  end

  test '用户对评论可以赞和取消赞' do
    assert_difference '@victor.likes.count' do
      @victor.like @comment
    end
    assert_difference '@victor.likes.count', -1 do
      @victor.dislike @comment
    end
  end
end
