require 'test_helper'

class Feeds::SendServiceTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @victor = users(:victor)
    params = { handler: @victor }
    @like_comment_params = params.merge(sourceable: comments(:three), name: 'liked.comment')
    @like_post_params = params.merge(sourceable: posts(:three), name: 'liked.post')
    @comment_params = params.merge(sourceable: comments(:three), name: 'commented.post')
  end

  test '赞一条评论，发送 feed' do
    assert_difference -> { comments(:three).author.feeds.count } do
      perform_enqueued_jobs do
        Feeds::SendService.create(@like_comment_params)
      end
    end
  end

  test '赞一条评论，评论作者是点赞者本人，不发送 feed' do
    assert_no_difference -> { comments(:one).author.feeds.count } do
      perform_enqueued_jobs do
        @like_comment_params[:sourceable] = comments(:one)
        Feeds::SendService.create(@like_comment_params)
      end
    end
  end

  test '赞一条评论，评论作者关闭通知，不发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { comments(:three).author.feeds.count } do
      perform_enqueued_jobs do
        Feeds::SendService.create(@like_comment_params)
      end
    end
  end

  test '赞一条主题，发送 feed' do
    assert_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Feeds::SendService.create(@like_post_params) }
    end
  end

  test '赞一条主题，主题作者是点赞者本人，不发送 feed' do
    assert_no_difference -> { posts(:one).author.feeds.count } do
      perform_enqueued_jobs do
        @like_post_params[:sourceable] = comments(:one)
        Feeds::SendService.create(@like_post_params)
      end
    end
  end

  test '赞一条主题，主题作者关闭通知，不发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { posts(:three).author.feeds.count } do
      perform_enqueued_jobs { Feeds::SendService.create(@like_post_params) }
    end
  end

  test '评论一条主题，发送 feed' do
    assert_difference -> { comments(:three).commentable.author.feeds.count } do
      perform_enqueued_jobs { Feeds::SendService.create(@comment_params) }
    end
  end

  test '评论一条主题，主题作者是评论者本人，不发送 feed' do
    assert_no_difference -> { comments(:one).commentable.author.feeds.count } do
      perform_enqueued_jobs do
        @comment_params[:sourceable] = comments(:one)
        Feeds::SendService.create(@comment_params)
      end
    end
  end

  test '评论一条主题，主题作者关闭通知，不发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { comments(:three).commentable.author.feeds.count } do
      perform_enqueued_jobs { Feeds::SendService.create(@comment_params) }
    end
  end

  test '回复提及某人，发送 feed' do
    assert_difference -> { comments(:five).replied_user.feeds.count } do
      perform_enqueued_jobs do
        params = { name: 'replied.comment', sourceable: comments(:five), handler: @victor }
        Feeds::SendService.create(params)
      end
    end
  end

  test '回复提及自己，不发送 feed' do
    assert_no_difference -> { comments(:four).replied_user.feeds.count } do
      perform_enqueued_jobs do
        params = { name: 'replied.comment', sourceable: comments(:four), handler: @victor }
        Feeds::SendService.create(params)
      end
    end
  end

  test '回复提及题主，发送 feed' do
    assert_difference -> { comments(:four).replied_user.feeds.count } do
      perform_enqueued_jobs do
        params = { name: 'replied.comment', sourceable: comments(:four), handler: users(:roc) }
        Feeds::SendService.create(params)
      end
    end
  end

  test '回复提及题主，题主关闭推送，发送 feed' do
    users(:victor).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_difference -> { comments(:four).replied_user.feeds.count } do
      perform_enqueued_jobs do
        params = { name: 'replied.comment', sourceable: comments(:four), handler: users(:roc) }
        Feeds::SendService.create(params)
      end
    end
  end

  test '发布新主题，给作者之外的其它圈子成员，发送 feed' do
    assert_difference -> { users(:yuki).feeds.count } do
      no_feed_to_author_after_post
    end
  end

  test '发布新主题，给作者之外的其它圈子成员，发送 feed，圈子成员关闭通知不给该成员发送 feed' do
    users(:yuki).membership_by_forum(forums(:one)).preference.update(feed_allowed: false)
    assert_no_difference -> { users(:yuki).feeds.count } do
      no_feed_to_author_after_post
    end
  end

  private

  def no_feed_to_author_after_post
    assert_no_difference -> { @victor.feeds.count } do
      perform_enqueued_jobs do
        params = { name: 'created.post', sourceable: posts(:one), handler: @victor }
        Feeds::SendService.create(params)
      end
    end
  end
end
