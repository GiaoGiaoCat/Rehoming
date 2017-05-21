require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test '验证内容' do
    p = Post.new content: '', user_id: users(:victor).id, forum_id: forums(:one).id
    assert_not p.valid?

    p.content = '1'
    assert p.valid?

    p.content = '1' * 10_000
    assert p.valid?

    p.content = '1' * 10_001
    assert_not p.valid?
  end

  test '验证图片附件' do
    p = Post.new content: 'content goes here', user_id: users(:victor).id, forum_id: forums(:one).id

    9.times do |i|
      p.attachments << Attachment.new(category: 'image', url: "#{i}*100")
    end
    assert_nothing_raised do
      p.save!
    end
    p.attachments << Attachment.new(category: 'image', url: 'url goes here')
    assert_not p.valid?
    assert p.errors.key?(:base)
  end

  test '验证视频附件' do
    p = Post.new(
      content:  'content goes here',
      user_id:  users(:victor).id,
      forum_id: forums(:one).id
    )

    1.times do |i|
      p.attachments << Attachment.new(category: 'video', url: "#{i}*100")
    end
    assert_nothing_raised do
      p.save!
    end
    p.attachments << Attachment.new(category: 'video', url: 'url goes here')
    assert_not p.valid?
    assert p.errors.key?(:base)
  end

  test '带标签的数据需正确持久化' do
    assert_nothing_raised do
      p = Post.new(
        content:  '#我是标签# content goes here',
        user_id:  users(:victor).id,
        forum_id: forums(:one).id
      )
      p.save!
    end
  end

  test '带 emoji 的数据需正确持久化' do
    assert_nothing_raised do
      p = Post.new(
        content:  '👍 content goes here',
        user_id:  users(:victor).id,
        forum_id: forums(:one).id
      )
      p.save!
    end
  end
end
