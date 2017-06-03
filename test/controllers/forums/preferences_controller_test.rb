require 'test_helper'

class Forums::PreferencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forum = forums(:one)
  end

  test '圈主可以更改圈子设置' do
    current_user.add_role :owner, @forum
    params_data = {
      data: {
        attributes: {
          postable_until_tomorrow: true
        }
      }
    }
    assert_changes -> { @forum.preference.reload.postable_until_tomorrow } do
      put forum_setting_url(@forum), params: params_data, headers: @headers
    end

    assert_response :success
  end

  test '非圈主不可以更改圈子设置' do
    current_user.remove_role :owner, @forum
    params_data = {
      data: {
        attributes: {
          postable_until_tomorrow: true
        }
      }
    }

    put forum_setting_url(@forum), params: params_data, headers: @headers
    assert_response 403
  end
end
