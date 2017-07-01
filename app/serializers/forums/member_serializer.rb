class Forums::MemberSerializer < ApplicationSerializer
  cache key: 'member'

  attributes :headimgurl
  attribute :nickname
  attribute :status
  attribute :roles

  delegate :status, to: :forum_membership

  def nickname
    object.forum_nickname(current_forum)
  end

  def roles
    object.role_names_by_forum(current_forum)
  end

  private

  def forum_membership
    object.forum_memberships.find_by(forum: current_forum)
  end

  def current_forum
    view_variables[:current_forum]
  end
end
