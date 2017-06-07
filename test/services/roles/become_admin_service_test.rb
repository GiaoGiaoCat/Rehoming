require 'test_helper'

class Roles::BecomeAdminServiceTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
    @user = @forum.members.first
  end

  test 'validations' do
    roc = users(:roc)

    fma = Roles::BecomeAdminService.new(forum: @forum, user: roc)
    assert_not fma.valid?
    assert fma.errors.key? :base

    fma = Roles::BecomeAdminService.new(forum: @forum, user: @user)
    assert fma.valid?
  end

  test '将成员设置为管理员' do
    fma = Roles::BecomeAdminService.new(forum: @forum, user: @user)
    assert fma.save
    assert @user.has_role? :admin, @forum
  end
end
