require 'test_helper'

class Forums::MembershipStateTest < ActiveSupport::TestCase
  setup do
    @roc = users(:roc)
    @forum = forums(:two)
  end

  test 'accept membership request' do
    assert_difference -> { @forum.membership_requests.count } do
      @roc.join_forum(@forum)
      @membership_request = @forum.membership_requests.find_by(user: @roc)
    end
    assert @membership_request.accept
    assert_equal 'active', @membership_request.status
  end

  test 'reject membership request' do
    assert_difference -> { @forum.membership_requests.count } do
      @roc.join_forum(@forum)
      @membership_request = @forum.membership_requests.find_by(user: @roc)
    end

    assert @membership_request.reject
    assert_equal 'rejected', @membership_request.status
  end

  test 'ignore membership request' do
    assert_difference -> { @forum.membership_requests.count } do
      @roc.join_forum(@forum)
      @membership_request = @forum.membership_requests.find_by(user: @roc)
    end

    assert @membership_request.ignore
    assert_equal 'ignored', @membership_request.status
  end
end
