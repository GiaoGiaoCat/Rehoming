require 'test_helper'

class Comments::CreateFormTest < ActiveSupport::TestCase
  setup do
    params = {
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:roc).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    @feed = Feeds::CreateForm.new(params)
  end

  test '创建 feed' do
    assert @feed.save
    assert @feed.object
    assert_equal 'new_post', @feed.event
    assert @feed.creator_id
  end

  test 'setup_object_attributes when sourceable is a post' do
    assert @feed.save
    assert @feed.forum_id
    assert @feed.forum_name
    assert posts(:one).content, @feed.content
  end

  test 'setup_object_attributes when sourceable is a comment' do
    params = {
      sourceable_id: comments(:one).id, sourceable_type: comments(:one).class,
      creator_id: users(:roc).id, user_id: users(:victor).id,
      event: 'commented.post'
    }
    feed = Feeds::CreateForm.create(params)

    assert feed.forum_id
    assert feed.forum_name
    assert_equal comments(:one).content, feed.content
  end
end
