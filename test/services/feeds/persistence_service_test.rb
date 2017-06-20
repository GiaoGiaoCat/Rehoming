require 'test_helper'

class Feeds::PersistenceServiceTest < ActiveSupport::TestCase
  test '持久化到 redis 中' do
    params = {
      id: SecureRandom.uuid,
      sourceable_id: Post.first.id, sourceable_type: Post.first.class, user_id: User.first.id, event: 'new_post'
    }
    feed = Feed.create(params)
    persistence = Feeds::PersistenceService.new(key: "feeds/#{feed.id}", feed: feed)
    assert persistence.save
    assert Redis.current.get("feeds/#{feed.id}")
  end
end
