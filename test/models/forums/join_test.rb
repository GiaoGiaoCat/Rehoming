require 'test_helper'

class Forums::JoinTest < ActiveSupport::TestCase
  test '验证必填项' do
    p = Forums::Join.new
    assert_not p.valid?
    assert p.errors.key? :user
    assert p.errors.key? :forum_id
  end

  test '验证不能重复加入' do
    forum_one = forums(:one)
    user_one = users(:victor)
    user_one.forums.append forum_one
    p = Forums::Join.new(forum_id: forum_one.id, user_id: user_one.id)
    assert p.valid?
  end

  test '合法数据需正确持久化' do
    assert_difference 'Forums::Membership.count', 1 do
      j = Forums::Join.new(forum_id: forums(:one).id, user_id: users(:yuki).id)
      assert j.valid?
      assert j.save
    end
  end
end
