class Forums::PostSerializer < PostSerializer
  cache key: 'forum_post'

  has_many :comments do
    object.comments.by_user(scope[:current_user], scope[:current_forum]).limit(5)
  end
end
