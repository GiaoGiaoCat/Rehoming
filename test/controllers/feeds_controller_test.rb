require 'test_helper'

class FeedsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get feeds_url, headers: @headers
    assert_response :success
  end

  test 'should update feed read status' do
    params = {
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:yuki).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    feed = Feeds::CreateForm.create(params).object

    assert_changes -> { Redis::FetchService.create(key: feed.cache_key).object.read } do
      patch feed_url(feed), headers: @headers
    end
    assert_response :success
  end
end
