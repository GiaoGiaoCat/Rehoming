require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
  end

  test 'forum load members should be check preference at first' do
    refute_empty @forum.members

    @forum.preference.update(member_list_protected: true)
    assert_nil @forum.members
  end
end
