class AuthorSerializer < ApplicationSerializer
  type 'authors'
  attributes :id, :headimgurl
  attribute :nickname


  def nickname
    return nickname unless group
    object.group_enrollments.find_by(group_id: group.id).nickname || nickname
  end
end
