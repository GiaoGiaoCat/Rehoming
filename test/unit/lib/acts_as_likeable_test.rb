require 'test_helper'

class ActsAsLikeableTest < ActiveSupport::TestCase
  def setup
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
    @comment = comments(:two)
    @victor.like @post_one
  end

  test '验证 likeable? 方法正确' do
    assert @post_one.likeable?
    assert_raises NoMethodError do
      @victor.likeable?
    end
  end

  test '验证 liked? 方法正确' do
    assert @victor.liked?(@post_one)
    assert_not @victor.liked?(@post_tow)
  end

  test '用户对帖子可以赞和取消赞' do
    assert_difference '@victor.likes.count' do
      @victor.like @post_two
    end
    assert_difference '@victor.likes.count', -1 do
      @victor.dislike @post_one
    end
  end

  test '不同重复赞同一个帖子或评论' do
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

  test '赞自己的帖子不产生动态' do
    assert_no_difference '@victor.feeds.count' do
      @victor.like @post_one
    end
  end

  test '赞别人的帖子产生动态' do
    assert_difference 'users(:yuki).feeds.count' do
      @victor.like posts(:three)
    end
  end
end
