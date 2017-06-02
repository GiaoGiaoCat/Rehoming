require 'test_helper'

class Forums::PreferenceTest < ActiveSupport::TestCase
  test 'validate postable_roles must of valid roles' do
    preference = forums(:one).preference

    preference.postable_roles = [10, 20]
    assert preference.valid?

    preference.postable_roles = [10, 90]
    assert_not preference.valid?
  end
end
