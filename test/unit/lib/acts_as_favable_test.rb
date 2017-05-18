require 'test_helper'

class ActsAsFavableTest < ActiveSupport::TestCase
  def setup
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
    @comment = comments(:one)
    @victor.favor @post_one
  end

  test '验证 favorable? 方法正确' do
    assert @post_one.favorable?
    assert_raises NoMethodError do
      @comment.favorable?
    end
  end

  test '验证 favored? 方法正确' do
    assert @victor.favored?(@post_one)
    assert_not @victor.favored?(@post_tow)
  end

  test '用户对帖子可以收藏和取消收藏' do
    assert_difference '@victor.favorites.count' do
      @victor.favor @post_two
    end
    assert_difference '@victor.favorites.count', -1 do
      @victor.unfavor @post_one
    end
  end

  test '不同重复收藏同一个帖子' do
    assert_difference '@victor.favorites.count', 0 do
      @victor.favor @post_one
    end
  end
end
