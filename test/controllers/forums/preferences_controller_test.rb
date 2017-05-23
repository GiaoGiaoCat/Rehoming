require 'test_helper'

class Forums::PreferencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
  end

  test 'should update forum preference' do
    params_data = {
      data: {
        attributes: {
          member_list_protected:   true,
          postable_until_tomorrow: false
        }
      }
    }
    assert_changes -> { @forum.preference.reload.postable_until_tomorrow } do
      put forum_preference_url(@forum), params: params_data, headers: @headers
    end

    assert_response :success
  end
end
