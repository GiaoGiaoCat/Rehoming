require 'test_helper'

class Posts::CreateFormTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
    @victor = users(:victor)
    @roc = users(:roc)
  end

  test '会员通过审核24小时后才能发帖' do
    @forum.preference.update(postable_until_tomorrow: true)

    post = Posts::CreateForm.new(forum: @forum, author: @victor, content: '#我是标签# content goes here')

    assert_not post.valid?
    assert post.errors.key?(:base)

    @victor.forum_memberships.find_by(forum: @forum).update_column(:accepted_at, Time.current.weeks_ago(1))
    assert post.valid?
  end

  test '用户需要在圈子中，会员状态为 active 能发帖' do
    post = Posts::CreateForm.new(forum: @forum, author: @roc, content: '#我是标签# content goes here')
    assert_not post.valid?
    assert post.errors.key?(:base)

    @victor.quit_forum(@forum)
    post = Posts::CreateForm.new(forum: @forum, author: @victor, content: '#我是标签# content goes here')
    assert_not post.valid?
  end

  test '会员状态为 blocked 能发帖' do
    Forums::BlockedMember.create(forum: @forum, user: @victor)
    post = Posts::CreateForm.new(forum: @forum, author: @victor, content: '#我是标签# content goes here')
    assert post.valid?
  end
end
