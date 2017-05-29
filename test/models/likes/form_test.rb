require 'test_helper'

class Likes::FormTest < ActiveSupport::TestCase
  test '帖子被赞时，帖子的作者应能收到动态' do
    post = posts(:one)
    assert_difference 'Feed.count', 1 do
      Likes::Form.create(
        liker:    users(:yuki),
        likeable: post
      )
      assert_equal Feed.last.targetable, post.author
    end
  end
end
