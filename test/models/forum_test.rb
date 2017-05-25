require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
  end

  test 'ensure_preference after create forum' do
    assert_difference -> { Forums::Preference.count } do
      @preference = Forum.create(name: 'test forum', category: 'wenyi')
    end
    assert @preference
  end

  test 'forum load members should be check preference at first' do
    refute_empty @forum.members

    @forum.preference.update(member_list_protected: true)
    assert_nil @forum.members
  end
end
