require 'test_helper'

class Forums::BlockedMemberTest < ActiveSupport::TestCase
  setup do
    @victor = users(:victor)
    @forum = forums(:one)
  end

  test 'block a member' do
    assert_difference -> { @forum.memberships.active.count }, -1 do
      blocking = Forums::BlockedMember.new(forum: @forum, user: @victor)
      blocking.save
      @membership = @forum.memberships.find_by(user: @victor)
    end

    assert_equal 'blocked', @membership.status
  end

  test 'block a member with decrypt user id' do
    assert_difference -> { @forum.memberships.active.count }, -1 do
      blocking = Forums::BlockedMember.new(forum: @forum, user_id: @victor.to_param)
      blocking.save
      @membership = @forum.memberships.find_by(user: @victor)
    end

    assert_equal 'blocked', @membership.status
  end

  test 'unblock a membership' do
    assert_difference -> { @forum.memberships.blocked.count } do
      Forums::BlockedMember.create(forum: @forum, user: @victor)
    end

    assert_difference -> { @forum.memberships.active.count } do
      blocking = Forums::BlockedMember.new(forum: @forum, user_id: @victor.to_param)
      blocking.destroy
    end

    membership = @forum.memberships.find_by(user: @victor)
    assert_equal 'active', membership.status
  end
end
