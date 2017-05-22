require 'test_helper'

class ActsAsPinableTest < ActiveSupport::TestCase
  def setup
    @victor = users(:victor)
    @post_pinned = posts(:one)
    @post_unpinned = posts(:two)
    @comment = comments(:one)
  end

  test '验证 pinable? 方法正确' do
    assert @post_pinned.pinable?
    assert_raises NoMethodError do
      @comment.pinable?
    end
  end

  test '返回的列表默认置顶贴排在第一位' do
    @victor.pin @post_unpinned

    assert_equal @post_unpinned, Post.first
    assert Post.first.sticky
  end

  test '置顶帖子' do
    @victor.pin @post_unpinned
    assert @post_unpinned.sticky
  end

  test '取消置顶' do
    @victor.unpin @post_pinned
    assert_not @post_pinned.sticky
  end

  test '一个小组只能有一条置顶帖子' do
    assert_equal 1, forums(:one).posts.by_pinned.size

    @victor.pin @post_unpinned
    assert_equal 1, forums(:one).posts.by_pinned.size
  end

  test '重复置顶同一个帖子不会做数据库操作' do
    assert_changes -> { @post_unpinned.updated_at } do
      @victor.pin @post_unpinned
    end

    assert_no_changes -> { @post_unpinned.updated_at } do
      @victor.pin @post_unpinned
    end
  end

  test '重复取消置顶同一个帖子不会做数据库操作' do
    assert_changes -> { @post_pinned.updated_at } do
      @victor.unpin @post_pinned
    end

    assert_no_changes -> { @post_pinned.updated_at } do
      @victor.unpin @post_pinned
    end
  end
end
