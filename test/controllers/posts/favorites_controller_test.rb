require 'test_helper'

class Posts::FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @post_favored = posts(:one)
    @post_unfavored = posts(:two)
  end

  test 'should create favorites' do
    assert_difference -> { @victor.favor_posts.count } do
      post post_favorite_url(@post_unfavored), headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end

  test 'should destroy favorites' do
    assert_difference -> { @victor.favor_posts.count }, -1 do
      delete post_favorite_url(@post_favored), headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end
end
