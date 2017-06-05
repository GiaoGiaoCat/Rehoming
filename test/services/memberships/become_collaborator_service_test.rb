require 'test_helper'

class Memberships::BecomeCollaboratorServiceTest < ActiveSupport::TestCase
  setup do
    @invitation = forums_invitations(:one)
    @roc = users(:roc)
  end

  test '用户通过邀请码成为嘉宾' do
    assert_difference -> { Forums::Membership.where(status: 'active').count } do
      service = Memberships::BecomeCollaboratorService.new(invitation_token: @invitation.token, user: @roc)
      assert service.save
    end

    @invitation.reload
    # 确认验证码被使用
    refute_nil @invitation.accepted_at
    assert_equal @roc, @invitation.user

    assert_includes @roc.roles.map(&:name), 'collaborator'
  end
end
