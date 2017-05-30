require 'test_helper'

class Comments::FormTest < ActiveSupport::TestCase
  test '仅对 post 进行评论时，只有 post 的作者能收到动态' do
    post_with_no_comment = posts(:post_with_no_comment)

    assert_difference 'post_with_no_comment.author.feeds.count' do
      assert_empty post_with_no_comment.comments
      assert_difference 'Feed.count', 1 do
        Comments::Form.create(
          author:     users(:roc),
          content:    '我要对 post 进行评论',
          commentable: post_with_no_comment
        )
      end
    end
  end

  test '对评论者进行回复且评论者与帖子作者非同一人时，评论的作者和帖子的作者都应收到动态' do
    comment_two = comments(:three)
    assert_not_equal comment_two.author.id, comment_two.commentable.author.id

    assert_difference 'Feed.count', 2 do
      Comments::Form.create(
        author:       users(:roc),
        content:      '我要对你的评论进行回复',
        commentable:  comment_two.commentable,
        replied_user: comment_two.author
      )
      assert_equal [comment_two.user_id, comment_two.commentable.user_id].sort, Feed.last(2).collect(&:targetable_id).sort
    end
  end

  test '对评论者进行回复且评论者与帖子作者是同一人时，只有评论的作者应收到动态' do
    comment_one = comments(:one)
    assert_equal comment_one.author.id, comment_one.commentable.author.id

    assert_difference 'Feed.count', 1 do
      Comments::Form.create(
        author:       users(:roc),
        content:      '我要对你的评论进行回复',
        commentable:  comment_one.commentable,
        replied_user: comment_one.author
      )
      assert_equal Feed.last.targetable, comment_one.author
    end
  end
end
