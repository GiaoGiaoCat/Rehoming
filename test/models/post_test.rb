require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # validates :content, presence: true, length: { in: 1..10_000 }
  # validate :images_limitation, :video_limitation
  test '验证内容' do
    p = Post.new content: ''
    assert_not p.valid?

    p.content = '1'
    assert p.valid?

    p.content = '1' * 10_000
    assert p.valid?

    p.content = '1' * 10_001
    assert_not p.valid?
  end

  test '验证图片附件' do
    p = Post.new content: 'content goes here'

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
    p = Post.new content: 'content goes here'

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
end
