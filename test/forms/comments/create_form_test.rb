require 'test_helper'

class Comments::CreateFormTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
    @post = posts(:one)
    @victor = users(:victor)
    @roc = users(:roc)
  end

  test '会员通过审核24小时后才能回复' do
    @forum.preference.update(postable_until_tomorrow: true)

    post = Comments::CreateForm.new(commentable: @post, author: @victor, content: '#我是标签# content goes here')

    assert_not post.valid?
    assert post.errors.key?(:base)

    @victor.forum_memberships.find_by(forum: @forum).update_column(:accepted_at, Time.current.weeks_ago(1))
    assert post.valid?
  end

  test '用户需要在圈子中，会员状态为 active 能回复' do
    post = Comments::CreateForm.new(commentable: @post, author: @roc, content: '#我是标签# content goes here')
    assert_not post.valid?
    assert post.errors.key?(:base)

    @victor.quit_forum(@forum)
    post = Comments::CreateForm.new(commentable: @post, author: @victor, content: '#我是标签# content goes here')
    assert_not post.valid?
  end

  test '会员状态为 blocked 能回复' do
    Forums::BlockedMember.create(forum: @forum, user: @victor)
    post = Comments::CreateForm.new(commentable: @post, author: @victor, content: '#我是标签# content goes here')
    assert post.valid?
  end

  test '圈子允许外部人员回复（用于帮助和反馈圈）' do
    post = Posts::CreateForm.create(forum: forums(:three), author: @victor, content: 'cool')
    comment = Comments::CreateForm.new(commentable: post, author: @roc, content: 'man')
    assert comment.valid?
  end
end
