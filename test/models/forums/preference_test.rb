require 'test_helper'

class Forums::PreferenceTest < ActiveSupport::TestCase
  test 'validate postable_roles must of valid roles' do
    preference = forums(:one).preference

    preference.postable_roles = [10, 20]
    assert preference.valid?

    preference.postable_roles = [10, 90]
    assert_not preference.valid?
  end

  test 'ensure_preference postable_roles correct after create forum' do
    forum = Forum.create(name: 'test forum', category: 'wenyi')

    assert_equal Forums::Membership.roles.values, forum.preference.postable_roles
  end
end
