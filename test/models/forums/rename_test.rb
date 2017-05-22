require 'test_helper'

class Forums::RenameTest < ActiveSupport::TestCase
  test '验证必填项' do
    p = Forums::Rename.new
    assert_not p.valid?
    assert p.errors.key? :name
    assert p.errors.key? :user_id
    assert p.errors.key? :forum_id
  end

  test '验证必须先处于已加入的状态，才能更改昵称' do
    forum_one = forums(:one)
    user = users(:yuki)
    p = Forums::Rename.new(
      forum_id: forum_one.id,
      user_id:  user.id,
      name:     '我是新的昵称'
    )
    assert_not p.valid?
    assert p.errors.key?(:base)
  end

  test '合法数据需正确持久化' do
    forum_one = forums(:one)
    user_one = users(:victor)
    Forums::Join.create(forum_id: forum_one.id, user_id: user_one.id)
    q = Forums::Rename.new(
      forum_id: forum_one.id,
      user_id:  user_one.id,
      name:     '我是新昵称'
    )
    assert q.valid?
    assert q.save
    assert_equal '我是新昵称',
                 user_one.forum_memberships.find_by(forum: forum_one).nickname
  end
end
