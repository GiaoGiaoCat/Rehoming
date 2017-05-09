require 'test_helper'

class Groups::QuitTest < ActiveSupport::TestCase
  test '验证必填项' do
    p = Groups::Quit.new
    assert_not p.valid?
    assert p.errors.key? :user_id
    assert p.errors.key? :group_id
  end

  test '验证必须先处于已加入的状态，才能退出' do
    group_one = groups(:one)
    user_one = users(:victor)
    p = Groups::Quit.new(group_id: group_one.id, user_id: user_one.id)
    assert_not p.valid?
    assert p.errors.key?(:base)
  end

  test '合法数据需正确持久化' do
    group_one = groups(:one)
    user_one = users(:victor)
    Groups::Join.create(group_id: group_one.id, user_id: user_one.id)
    assert_difference 'Groups::Enrollment.count', -1 do
      q = Groups::Quit.new(group_id: group_one.id, user_id: user_one.id)
      assert q.valid?
      assert q.save
    end
  end
end
