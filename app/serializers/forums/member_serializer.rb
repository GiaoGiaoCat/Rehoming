class Forums::MemberSerializer < ApplicationSerializer
  cache key: 'members'

  attributes :headimgurl
  attribute :nickname
  attribute :status

  def nickname
    return nickname unless forum
    forum_membership.preference.nickname
  end

  def status
    forum_membership.status
  end

  private

  def forum_membership
    object.forum_memberships.find_by(forum: forum)
  end
end
