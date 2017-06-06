class Posts::CreateService < ActiveType::Record[Post]
  validate :user_should_in_forum
  validate :postable_until_tomorrow
  validate :author_role_can_post

  private

  def user_should_in_forum
    errors.add :base, :not_in_forum unless author_membership
  end

  def postable_until_tomorrow
    return unless forum.preference.postable_until_tomorrow
    errors.add :base, :postable_until_tomorrow if author_membership.created_at.next_day > Time.current
  end

  def author_role_can_post
    roles = Role::PERMISSIONS & forum.postable_roles & author.roles.where(resource: forum).map(&:name)
    errors.add :base, :no_permissions if roles.empty?
  end

  def author_membership
    membership = author.forum_memberships.find_by(forum: forum)
    membership if membership&.active? || membership&.blocked?
  end
end
