class Forums::MemberSerializer < ApplicationSerializer
  cache key: 'members'

  attributes :headimgurl
  attribute :nickname
  attribute :status

  delegate :status, to: :forum_membership

  def nickname
    return nickname unless current_forum
    forum_membership.preference.nickname
  end

  private

  def forum_membership
    object.forum_memberships.find_by(forum: current_forum)
  end

  def current_forum
    view_variables[:current_forum]
  end
end
