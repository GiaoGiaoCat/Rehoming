require 'test_helper'

class Users::ForumPreferencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @forum = forums(:one)
  end

  test 'should update forum preference' do
    params_data = { data: { attributes: { nickname: '老王' } } }
    assert_changes -> { @victor.forum_preferences.find_by(forum: @forum).nickname } do
      put forum_preference_url(@forum), params: params_data, headers: @headers
    end

    assert_response :success
  end
end
