require 'test_helper'

class Forums::MembershipRequestTest < ActiveSupport::TestCase
  setup do
    @roc = users(:roc)
    @forum_a = forums(:one)
    @forum_b = forums(:two)
  end

  test 'save membership request run state machines' do
    assert_difference -> { @forum_b.membership_requests.count } do
      @roc.join_forum(@forum_b)
      @membership_request = @forum_b.membership_requests.find_by(user: @roc)
    end

    @membership_request.action = 'accept'
    assert @membership_request.update_status
    assert_equal 'active', @membership_request.status
  end

  test 'can not save membership request with invalid state' do
    assert_difference -> { @forum_b.membership_requests.count } do
      @roc.join_forum(@forum_b)
      @membership_request = @forum_b.membership_requests.find_by(user: @roc)
    end

    @membership_request.action = 'xyz'
    assert_not @membership_request.valid?
    assert @membership_request.errors.key? :action
    assert_equal 'pending', @membership_request.status
  end

  test 'should be auto approval when forum membership approval needed is false' do
    assert_difference -> { @forum_a.forum_memberships.count } do
      @roc.join_forum(@forum_a)
      @forum_membership = @forum_a.forum_memberships.find_by(user: @roc)
    end

    assert_equal 'active', @forum_membership.status
  end
end
