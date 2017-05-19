require 'test_helper'

class ActsAsRecommendableTest < ActiveSupport::TestCase
  def setup
    @victor = users(:victor)
    @post_recommended = posts(:one)
    @post_unrecommended = posts(:two)
    @comment = comments(:one)
  end

  test '验证 pinable? 方法正确' do
    assert @post_recommended.recommendable?
    assert_raises NoMethodError do
      @comment.recommendable?
    end
  end

  test '加精和取消加精' do
    @victor.recommend @post_unrecommended
    assert @post_unrecommended.recommended

    @victor.unrecommend @post_unrecommended
    assert_not @post_unrecommended.recommended
  end

  test '重复加精同一个帖子不会做数据库操作' do
    assert_changes -> { @post_unrecommended.updated_at } do
      @victor.recommend @post_unrecommended
    end

    assert_no_changes -> { @post_unrecommended.updated_at } do
      @victor.recommend @post_unrecommended
    end
  end

  test '重复取消加精同一个帖子不会做数据库操作' do
    assert_changes -> { @post_recommended.updated_at } do
      @victor.unrecommend @post_recommended
    end

    assert_no_changes -> { @post_recommended.updated_at } do
      @victor.unrecommend @post_recommended
    end
  end
end
