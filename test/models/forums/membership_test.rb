require 'test_helper'

class Forums::MembershipTest < ActiveSupport::TestCase
  setup do
    @roc = users(:roc)
    @forum = forums(:one)
  end

  test 'ensure_preference after create membership' do
    assert_difference -> { Users::ForumPreference.count } do
      @roc.join_forum(@forum)
      @membership = @roc.forum_memberships.find_by(forum: @forum)
    end

    assert @membership.preference
    assert_equal @roc.nickname, @membership.preference.nickname
  end

  test 'preference' do
    membership = Forums::Membership.first
    assert membership.preference
  end

  test 'join_again' do
    membership = Forums::Membership.first
    assert_changes -> { membership.status } do
      membership.quit!
    end

    assert_changes -> { membership.status } do
      membership.join_again
    end
  end
end
