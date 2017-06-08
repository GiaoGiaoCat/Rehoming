require 'test_helper'

class Roles::ReduceServiceTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
    @invitation = forums_invitations(:one)
    @roc = users(:roc)
  end

  test '管理员删除一个用户的嘉宾身份' do
    @roc.join_forum(@forum)
    @roc.add_role :collaborator, @forum
    assert_difference -> { @roc.roles.reload.count }, -1 do
      Roles::ReduceService.create(forum: @forum, user: @roc, role: :collaborator)
    end
  end
end
