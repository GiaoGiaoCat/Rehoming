require 'test_helper'

class Forums::BlockedMembershipTest < ActiveSupport::TestCase
  setup do
    @victor = users(:victor)
    @forum = forums(:one)
  end

  test 'block a membership' do
    assert_difference -> { @forum.forum_memberships.active.count }, -1 do
      blocking = Forums::BlockedMembership.new(forum: @forum, user: @victor)
      blocking.save
      @membership = @forum.forum_memberships.find_by(user: @victor)
    end

    assert_equal 'blocked', @membership.status
  end
end
