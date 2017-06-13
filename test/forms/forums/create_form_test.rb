require 'test_helper'

class Forums::CreateFormTest < ActiveSupport::TestCase
  setup do
    @victor = users(:victor)
  end

  test '创建圈子需要提交正确的参数' do
    f = Forums::CreateForm.create(form_object: Forum.new, moderator: @victor, name: 'test forum')
    assert_not f.valid?
    assert f.errors.key? :category
  end

  test '用户创建圈子后，自动成为圈主' do
    assert_difference -> { @victor.roles.count } do
      Forums::CreateForm.create(form_object: Forum.new, moderator: @victor, name: 'test forum', category: 10)
    end
    assert @victor.reload.has_role?(:moderator, Forum.last)
  end
end
