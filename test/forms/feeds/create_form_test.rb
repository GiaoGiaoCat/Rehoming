require 'test_helper'

class Comments::CreateFormTest < ActiveSupport::TestCase
  test '创建 feed' do
    params = {
      sourceable_id: posts(:one).id, sourceable_type: posts(:one).class,
      creator_id: users(:yuki).id, user_id: users(:victor).id,
      event: 'new_post'
    }
    feed = Feeds::CreateForm.new(params)
    assert feed.save
    assert_equal 'new_post', feed.event
    assert feed.id
    assert feed.creator_id
  end
end
