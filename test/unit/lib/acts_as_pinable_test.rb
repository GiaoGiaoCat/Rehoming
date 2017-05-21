require 'test_helper'

class ActsAsPinableTest < ActiveSupport::TestCase
  def setup
    @victor = users(:victor)
    @post_pined = posts(:one)
    @post_unpined = posts(:two)
    @comment = comments(:one)
  end

  test '验证 pinable? 方法正确' do
    assert @post_pined.pinable?
    assert_raises NoMethodError do
      @comment.pinable?
    end
  end

  test '返回的列表默认置顶贴排在第一位' do
    @victor.pin @post_unpined

    assert_equal @post_unpined, Post.first
    assert Post.first.sticky
  end

  test '用户可以置顶帖子和取消置顶' do
    @victor.pin @post_unpined
    assert @post_unpined.sticky

    @victor.unpin @post_unpined
    assert_not @post_unpined.sticky
  end

  test '一个小组只能有一条置顶帖子' do
    assert_equal 1, forums(:one).posts.sticky.size

    @victor.pin @post_unpined
    assert_equal 1, forums(:one).posts.sticky.size
  end

  test '重复置顶同一个帖子不会做数据库操作' do
    assert_changes -> { @post_unpined.updated_at } do
      @victor.pin @post_unpined
    end

    assert_no_changes -> { @post_unpined.updated_at } do
      @victor.pin @post_unpined
    end
  end

  test '重复取消置顶同一个帖子不会做数据库操作' do
    assert_changes -> { @post_pined.updated_at } do
      @victor.unpin @post_pined
    end

    assert_no_changes -> { @post_pined.updated_at } do
      @victor.unpin @post_pined
    end
  end
end
