require 'test_helper'

class FeedsControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @feed = feeds(:one)
  # end

  test 'should get index' do
    get feeds_url, headers: @headers
    assert_response :success
  end

  test 'should update feed read status' do
    assert_difference -> { Feed.where(read: true).count } do
      patch feed_url(@feed), headers: @headers
    end
    assert_response :success
  end
end
