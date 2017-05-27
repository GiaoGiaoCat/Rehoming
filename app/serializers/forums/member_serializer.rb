class Forums::MemberSerializer < ApplicationSerializer
  cache key: 'members'

  attributes :headimgurl
  attribute :nickname
  attribute :status

  delegate :status, to: :forum_membership

  def nickname
    return nickname unless forum
    forum_membership.preference.nickname
  end

  private

  def forum_membership
    object.forum_memberships.find_by(forum: forum)
  end
end
