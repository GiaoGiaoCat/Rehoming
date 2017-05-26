require 'test_helper'

class Forums::MembershipRequestTest < ActiveSupport::TestCase
  setup do
    @roc = users(:roc)
    @forum = forums(:one)
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

  test 'save membership request run state machines' do
    assert_difference -> { @forum.membership_requests.count } do
      @roc.join_forum(@forum)
      @membership_request = @forum.membership_requests.find_by(user: @roc)
    end

    @membership_request.action = 'accept'
    assert @membership_request.update_status
    assert_equal 'active', @membership_request.status
  end

  test 'can not save membership request with invalid state' do
    assert_difference -> { @forum.membership_requests.count } do
      @roc.join_forum(@forum)
      @membership_request = @forum.membership_requests.find_by(user: @roc)
    end

    @membership_request.action = 'xyz'
    assert_not @membership_request.valid?
    assert @membership_request.errors.key? :action
    assert_equal 'pending', @membership_request.status
  end
end
