class UserSerializer < ApplicationSerializer
  cache key: 'users'

  attribute :headimgurl
  attribute :nickname

  def nickname
    return nickname unless current_forum
    object.forum_memberships.find_by(forum: current_forum).preference.nickname
  end
end
