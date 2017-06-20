require 'test_helper'

class FeedTest < Minitest::Test
  def test_create_feed
    params = {
      sourceable_id: Post.first.id, sourceable_type: Post.first.class, user_id: User.first.id, event: 'new_post'
    }
    feed = Feed.new(params)
    assert feed.save
    assert feed.id
    assert feed.created_at
  end

  def test_make_as_read
    params = {
      sourceable_id: Post.first.id, sourceable_type: Post.first.class, user_id: User.first.id, event: 'new_post'
    }
    feed = Feed.create(params)
    feed.make_as_read
    assert feed.read
  end
end
