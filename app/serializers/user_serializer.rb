class UserSerializer < ApplicationSerializer
  cache key: 'users'

  attribute :headimgurl
  attribute :nickname

  def nickname
    return nickname unless forum
    object.forum_memberships.find_by(forum_id: forum.id)&.nickname ||
      object.nickname
  end
end
