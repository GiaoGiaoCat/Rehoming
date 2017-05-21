class UserSerializer < ApplicationSerializer
  cache key: 'users'

  attribute :headimgurl
  attribute :nickname

  def nickname
    return nickname unless group
    object.group_enrollments.find_by(group_id: group.id)&.nickname ||
      object.nickname
  end
end
