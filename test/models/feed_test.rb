require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  def test_make_as_read
    params = {
      id: SecureRandom.uuid,
      sourceable_id: Post.first.id, sourceable_type: Post.first.class, user_id: User.first.id, event: 'new_post'
    }
    feed = Feed.create(params)
    feed.make_as_read
    assert feed.read
  end
end
