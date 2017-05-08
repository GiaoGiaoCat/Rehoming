require 'test_helper'

class Groups::JoinTest < ActiveSupport::TestCase
  test '验证必填项' do
    p = Groups::Join.new
    assert_not p.valid?
    assert p.errors.key? :user_id
    assert p.errors.key? :group_id
  end

  test '验证不能重复加入' do
    group_one = groups(:one)
    user_one = users(:victor)
    user_one.groups.append group_one
    p = Groups::Join.new(group_id: group_one.id, user_id: user_one.id)
    assert_not p.valid?
    assert p.errors.key?(:base)
  end

  test '合法数据需正确持久化' do
    assert_difference 'Groups::Enrollment.count', 1 do
      j = Groups::Join.new(group_id: groups(:one).id, user_id: users(:victor).id)
      assert j.valid?
      assert j.save
    end
  end
end
