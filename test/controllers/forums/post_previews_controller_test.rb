require 'test_helper'

class Forums::PostPreviewsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get forum_post_previews_url(forums(:one))
    assert_response :success
  end

  test 'show get show' do
    get forum_post_preview_url(forums(:one), posts(:one))
    assert_response :success
  end
end
