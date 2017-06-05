require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
    @victor = users(:victor)
    @roc = users(:roc)
  end
  test '验证图片附件' do
    p = @forum.posts.new(content: '#我是标签# content goes here', user_id: @victor.id)
    9.times { |i| p.attachments << Attachment.new(category: 'image', url: "#{i}*100") }
    assert p.save
    p.attachments << Attachment.new(category: 'image', url: 'url goes here')
    assert_not p.valid?
    assert p.errors.key?(:base)
  end

  test '验证视频附件' do
    p = @forum.posts.new(content: '👍 content goes here', user_id: @victor.id, forum_id: @forum.id)
    1.times { |i| p.attachments << Attachment.new(category: 'video', url: "#{i}*100") }
    assert p.save
    p.attachments << Attachment.new(category: 'video', url: 'url goes here')
    assert_not p.valid?
    assert p.errors.key?(:base)
  end

  test '发帖需要24小时' do
    @forum.preference.update(postable_until_tomorrow: true)
    p = @forum.posts.new(content: '#我是标签# content goes here', user_id: @victor.id)
    assert_not p.valid?
    assert p.errors.key?(:base)

    @victor.forum_memberships.find_by(forum: @forum).update_column(:created_at, Time.current.weeks_ago(1))
    assert p.valid?
  end

  test '用户需要在圈子中，会员状态为 active 能发帖' do
    p = @forum.posts.new(content: '#我是标签# content goes here', user_id: @roc.id)
    assert_not p.valid?
    assert p.errors.key?(:base)

    @victor.quit_forum(@forum)
    p = @forum.posts.new(content: '#我是标签# content goes here', user_id: @victor.id)
    assert_not p.valid?
  end

  test '会员状态为 blocked 能发帖' do
    Forums::BlockedMember.create(forum: @forum, user: @victor)

    p = @forum.posts.new(content: '#我是标签# content goes here', user_id: @victor.id)
    assert p.valid?
  end
end
