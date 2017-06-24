require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @victor = users(:victor)
    @roc = users(:roc)
    @forum = forums(:one)
  end

  test 'join forum should create a membership request with active status' do
    assert_difference -> { @roc.forum_memberships.count } do
      @roc.join_forum(@forum)
    end

    forum_membership = @forum.memberships.find_by(user: @roc)
    assert_equal 'active', forum_membership.status
  end

  test 'join forum should create a membership request with pending status' do
    assert_difference -> { @roc.membership_requests.count } do
      @roc.join_forum(forums(:two))
    end

    membership_request = forums(:two).membership_requests.find_by(user: @roc)
    assert_equal 'pending', membership_request.status
  end

  test 'quit forum should change membership status to exited' do
    assert_difference -> { @victor.forum_memberships.active.count }, -1 do
      @victor.quit_forum(@forum)
    end

    membership = @victor.forum_memberships.find_by(forum: @forum)
    assert_equal 'exited', membership.status
  end

  test 'user can join forum again after quit' do
    assert_difference -> { @victor.forum_memberships.active.count }, -1 do
      @victor.quit_forum(@forum)
    end

    assert_difference -> { @victor.forum_memberships.active.count } do
      @victor.join_forum(@forum)
    end
  end

  test 'user has same role when rejoin forum' do
    assert @victor.add_role(:admin, @forum)
    @victor.quit_forum(@forum)
    @victor.join_forum(@forum)
    assert @victor.has_role?(:admin, @forum)
  end

  test 'membership_by_forum method' do
    assert_equal 'active', @victor.membership_by_forum(@forum).status
  end

  test 'forum_nickname method' do
    assert @victor.forum_nickname(@forum)
    refute_equal @victor.nickname, @victor.forum_nickname(@forum)
  end
end
