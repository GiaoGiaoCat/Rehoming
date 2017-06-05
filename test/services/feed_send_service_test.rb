require 'test_helper'

class FeedSendServiceTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @victor = users(:victor)
    payload = { handler: @victor }
    @like_comment_payload = payload.merge(sourceable: comments(:three))
    @like_post_payload = payload.merge(sourceable: posts(:three))
    @comment_payload = payload.merge(sourceable: posts(:three))
    @reply_payload = payload.merge(sourceable: comments(:five))
    @post_payload = payload.merge(sourceable: posts(:one))
  end

  test '赞一条评论，发送 feed' do
    assert_difference -> { comments(:three).author.feeds.count } do
      perform_enqueued_jobs do
        Services::Feeds::Create.call('liked.comment', SecureRandom.base58, @like_comment_payload)
      end
    end
  end

  test '赞一条评论，评论作者是点赞者本人，不发送 feed' do
    assert_no_difference -> { comments(:one).author.feeds.count } do
      perform_enqueued_jobs do
        payload = { sourceable: comments(:one), handler: @victor }
        Services::Feeds::Create.call('liked.comment', SecureRandom.base58, payload)
      end
    end
  end

  test '赞一条评论，评论作者关闭通知，不发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { comments(:three).author.feeds.count } do
      perform_enqueued_jobs do
        Services::Feeds::Create.call('liked.comment', SecureRandom.base58, @like_comment_payload)
      end
    end
  end

  test '赞一条主题，发送 feed' do
    assert_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Services::Feeds::Create.call('liked.post', SecureRandom.base58, @like_post_payload) }
    end
  end

  test '赞一条主题，主题作者是点赞者本人，不发送 feed' do
    assert_no_difference -> { posts(:one).author.feeds.count } do
      perform_enqueued_jobs do
        payload = { sourceable: posts(:one), handler: @victor }
        Services::Feeds::Create.call('liked.post', SecureRandom.base58, payload)
      end
    end
  end

  test '赞一条主题，主题作者关闭通知，不发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Services::Feeds::Create.call('liked.post', SecureRandom.base58, @like_post_payload) }
    end
  end

  test '评论一条主题，发送 feed' do
    assert_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Services::Feeds::Create.call('commented.post', SecureRandom.base58, @comment_payload) }
    end
  end

  test '评论一条主题，主题作者是评论者本人，不发送 feed' do
    assert_no_difference -> { posts(:one).author.feeds.count } do
      perform_enqueued_jobs do
        payload = { sourceable: posts(:one), handler: @victor }
        Services::Feeds::Create.call('commented.post', SecureRandom.base58, payload)
      end
    end
  end

  test '评论一条主题，主题作者关闭通知，不发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Services::Feeds::Create.call('commented.post', SecureRandom.base58, @comment_payload) }
    end
  end

  test '回复提及某人，发送 feed' do
    assert_difference -> { comments(:five).replied_user.feeds.count } do
      perform_enqueued_jobs { Services::Feeds::Create.call('replied.comment', SecureRandom.base58, @reply_payload) }
    end
  end

  test '回复提及自己，不发送 feed' do
    assert_no_difference -> { comments(:four).replied_user.feeds.count } do
      perform_enqueued_jobs do
        payload = { sourceable: comments(:four), handler: @victor }
        Services::Feeds::Create.call('replied.comment', SecureRandom.base58, payload)
      end
    end
  end

  test '回复提及题主，不发送 feed' do
    assert_no_difference -> { comments(:five).replied_user.feeds.count } do
      perform_enqueued_jobs do
        payload = { sourceable: comments(:five), handler: users(:roc) }
        Services::Feeds::Create.call('replied.comment', SecureRandom.base58, payload)
      end
    end
  end

  test '发布新主题，给作者之外的其它圈子成员，发送 feed' do
    assert_difference -> { users(:yuki).feeds.count } do
      assert_no_difference -> { @victor.feeds.count } do
        perform_enqueued_jobs { Services::Feeds::Create.call('created.post', SecureRandom.base58, @post_payload) }
      end
    end
  end
end
