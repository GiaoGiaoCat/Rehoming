require 'test_helper'

class Groups::RenameTest < ActiveSupport::TestCase
  test '验证必填项' do
    p = Groups::Rename.new
    assert_not p.valid?
    assert p.errors.key? :name
    assert p.errors.key? :user_id
    assert p.errors.key? :group_id
  end

  test '验证必须先处于已加入的状态，才能更改昵称' do
    group_one = groups(:one)
    user_one = users(:victor)
    p = Groups::Rename.new(
      group_id: group_one.id,
      user_id:  user_one.id,
      name:     '我是新的昵称'
    )
    assert_not p.valid?
    assert p.errors.key?(:base)
  end

  test '合法数据需正确持久化' do
    group_one = groups(:one)
    user_one = users(:victor)
    Groups::Join.create(group_id: group_one.id, user_id: user_one.id)
    q = Groups::Rename.new(
      group_id: group_one.id,
      user_id:  user_one.id,
      name:     '我是新昵称'
    )
    assert q.valid?
    assert q.save
    assert_equal '我是新昵称',
                 user_one.group_enrollments.find_by(group: group_one).nickname
  end
end
