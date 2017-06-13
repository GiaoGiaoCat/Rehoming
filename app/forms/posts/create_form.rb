class Posts::CreateForm < ApplicationForm
  attribute :forum
  attribute :author

  validate :user_should_in_forum
  validate :postable_until_tomorrow
  validate :author_role_can_post

  Post.column_names.each { |attr| delegate attr.to_sym, "#{attr}=".to_sym, to: :form_object }
  delegate :attachments_attributes=, to: :form_object
  delegate :forum_memberships, to: :author

  private

  def sync
    form_object.save
  end

  def setup_associations
    form_object.forum = forum
    form_object.author = author
  end

  def user_should_in_forum
    errors.add :base, :not_in_forum unless author_membership
  end

  def postable_until_tomorrow
    return unless forum.postable_until_tomorrow?
    errors.add :base, :postable_until_tomorrow if author_membership.created_at.next_day > Time.current
  end

  def author_role_can_post
    postable_roles = forum.postable_roles
    return if postable_roles.empty?
    roles = Role::PERMISSIONS & postable_roles & author.roles.where(resource: forum).map(&:name)
    errors.add :base, :no_permissions if roles.empty?
  end

  def author_membership
    forum_memberships.available.find_by(forum: forum)
  end
end
