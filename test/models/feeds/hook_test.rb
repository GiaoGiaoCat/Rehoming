require 'test_helper'

class Feeds::HookTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @victor = users(:victor)
    @like_comment_hook_params =
      {
        name: 'liked.comment',
        transaction_id: SecureRandom.base58,
        payload: { obj_id: comments(:three).id, handler_id: @victor.id }
      }
    @like_post_hook_params =
      {
        name: 'liked.post',
        transaction_id: SecureRandom.base58,
        payload: { obj_id: posts(:three).id, handler_id: @victor.id }
      }
    @comment_hook_params =
      {
        name: 'commented.post',
        transaction_id: SecureRandom.base58,
        payload: { obj_id: posts(:three).id, handler_id: @victor.id }
      }
    @reply_hook_params =
      {
        name: 'replied.comment',
        transaction_id: SecureRandom.base58,
        payload: { obj_id: comments(:five).id, handler_id: @victor.id }
      }
  end

  test '赞一条评论，发送 feed' do
    assert_difference -> { comments(:three).author.feeds.count } do
      perform_enqueued_jobs { Feeds::Hook.create(@like_comment_hook_params) }
    end
  end

  test '赞一条评论，评论作者是点赞者本人，不发送 feed' do
    assert_no_difference -> { comments(:one).author.feeds.count } do
      perform_enqueued_jobs do
        params = @like_comment_hook_params.merge(payload: { obj_id: comments(:one).id, handler_id: @victor.id })
        Feeds::Hook.create(params)
      end
    end
  end

  test '赞一条评论，评论作者关闭通知，不发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { comments(:three).author.feeds.count } do
      perform_enqueued_jobs { Feeds::Hook.create(@like_comment_hook_params) }
    end
  end

  test '赞一条主题，发送 feed' do
    assert_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Feeds::Hook.create(@like_post_hook_params) }
    end
  end

  test '赞一条主题，主题作者是点赞者本人，不发送 feed' do
    assert_no_difference -> { posts(:one).author.feeds.count } do
      perform_enqueued_jobs do
        Feeds::Hook.create(@like_post_hook_params.merge(payload: { obj_id: posts(:one).id, handler_id: @victor.id }))
      end
    end
  end

  test '赞一条主题，主题作者关闭通知，不发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Feeds::Hook.create(@like_post_hook_params) }
    end
  end

  test '评论一条主题，发送 feed' do
    assert_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Feeds::Hook.create(@comment_hook_params) }
    end
  end

  test '评论一条主题，主题作者是评论者本人，不发送 feed' do
    assert_no_difference -> { posts(:one).author.feeds.count } do
      perform_enqueued_jobs do
        Feeds::Hook.create(@comment_hook_params.merge(payload: { obj_id: posts(:one).id, handler_id: @victor.id }))
      end
    end
  end

  test '评论一条主题，主题作者关闭通知，不发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Feeds::Hook.create(@comment_hook_params) }
    end
  end

  test '回复提及某人，发送 feed' do
    assert_difference -> { comments(:five).replied_user.feeds.count } do
      perform_enqueued_jobs { Feeds::Hook.create(@reply_hook_params) }
    end
  end

  test '回复提及自己，不发送 feed' do
    assert_no_difference -> { comments(:four).replied_user.feeds.count } do
      perform_enqueued_jobs do
        Feeds::Hook.create(@reply_hook_params.merge(payload: { obj_id: comments(:four).id, handler_id: @victor.id }))
      end
    end
  end

  test '回复提及题主，不发送 feed' do
    assert_no_difference -> { comments(:five).replied_user.feeds.count } do
      perform_enqueued_jobs do
        params = @reply_hook_params.merge(payload: { obj_id: comments(:five).id, handler_id: users(:roc).id })
        Feeds::Hook.create(params)
      end
    end
  end
end
