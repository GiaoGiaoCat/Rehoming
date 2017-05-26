require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
    @vitor = users(:victor)
    @roc = users(:roc)
  end

  test 'join forum should create a membership request with active status' do
    assert_difference -> { @roc.forum_memberships.count } do
      @roc.join_forum(@forum)
    end

    forum_membership = @forum.forum_memberships.find_by(user: @roc)
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
    assert_difference -> { @vitor.forum_memberships.active.count }, -1 do
      @vitor.quit_forum(@forum)
    end

    membership = @vitor.forum_memberships.find_by(forum: @forum)
    assert_equal 'exited', membership.status
  end

  test 'user can join forum again after quit' do
    assert_difference -> { @vitor.forum_memberships.active.count }, -1 do
      @vitor.quit_forum(@forum)
    end

    assert_difference -> { @vitor.forum_memberships.active.count } do
      @vitor.join_forum(@forum)
    end
  end
end
