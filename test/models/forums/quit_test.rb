require 'test_helper'

class Forums::QuitTest < ActiveSupport::TestCase
  test '验证必填项' do
    p = Forums::Quit.new
    assert_not p.valid?
    assert p.errors.key? :user_id
    assert p.errors.key? :forum_id
  end

  test '验证必须先处于已加入的状态，才能退出' do
    forum_one = forums(:one)
    user = users(:yuki)
    p = Forums::Quit.new(forum_id: forum_one.id, user_id: user.id)
    assert_not p.valid?
    assert p.errors.key?(:base)
  end

  test '合法数据需正确持久化' do
    forum_one = forums(:one)
    user = users(:yuki)
    Forums::Join.create(forum_id: forum_one.id, user_id: user.id)
    assert_difference 'Forums::Membership.count', -1 do
      q = Forums::Quit.new(forum_id: forum_one.id, user_id: user.id)
      assert q.valid?
      assert q.save
    end
  end
end
