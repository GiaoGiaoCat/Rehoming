require 'test_helper'

class Posts::RecommendationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @victor = users(:victor)
    @post_one = posts(:one)
    @post_two = posts(:two)
  end

  test 'should create recommendation' do
    assert_difference -> { Post.recommended.count } do
      post post_recommendation_url(@post_two), headers: @headers
    end

    assert_response :success
    assert_equal 201, @response.status
  end

  test 'should destroy recommendation' do
    assert_difference -> { Post.recommended.count }, -1 do
      delete post_recommendation_url(@post_one), headers: @headers
    end

    assert_response :success
    assert_equal 204, @response.status
  end
end
