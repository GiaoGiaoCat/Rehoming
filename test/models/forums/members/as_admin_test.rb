require 'test_helper'

class Forums::AsAdminTest < ActiveSupport::TestCase
  setup do
    @forum = forums(:one)
    @user = @forum.members.first
  end

  test 'validations' do
    roc = users(:roc)

    fma = Forums::Members::AsAdmin.new(forum: @forum, user: roc)
    assert_not fma.valid?
    assert fma.errors.key? :base

    fma = Forums::Members::AsAdmin.new(forum: @forum, user: @user)
    assert fma.valid?
  end

  test '将成员设置为管理员' do
    fma = Forums::Members::AsAdmin.new(forum: @forum, user: @user)
    assert fma.save
    assert @user.has_role? :admin, @forum
  end

  test '将成员取消掉管理员' do
    fma = Forums::Members::AsAdmin.new(forum: @forum, user: @user)
    assert fma.save
    assert @user.has_role? :admin, @forum

    fma = Forums::Members::AsAdmin.new(forum: @forum, user: @user)
    assert fma.destroy
    assert_empty @user.roles
  end
end
