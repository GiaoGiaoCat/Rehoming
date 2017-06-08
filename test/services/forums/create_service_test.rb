require 'test_helper'

class Forums::CreateServiceTest < ActiveSupport::TestCase
  setup do
    @victor = users(:victor)
  end

  test '用户创建圈子后，自动成为圈主' do
    assert_difference -> { @victor.roles.count } do
      Forums::CreateService.create(moderator: @victor, name: 'test forum', category: 20)
    end
    assert @victor.reload.has_role?(:moderator, Forum.last)
  end
end
