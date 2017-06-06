require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
  end

  test 'ensure_preference after create forum' do
    assert_difference -> { Forums::Preference.count } do
      @new_forum = Forum.create(name: 'test forum', category: 'wenyi')
    end
    assert @new_forum.preference
  end

  test '论坛可见的会员列表由 member_list_protected 决定' do
    refute_empty @forum.visible_members

    @forum.preference.update(member_list_protected: true)
    assert_nil @forum.visible_members
  end
end
