class Posts::CreateForm < ApplicationForm
  include ValidPostingRights

  attribute :forum
  attribute :author

  validate :author_role_can_post

  Post.column_names.each { |attr| delegate attr.to_sym, "#{attr}=".to_sym, to: :object }
  delegate :attachments_attributes=, to: :object
  delegate :forum_memberships, to: :author

  private

  def setup_associations
    object.forum = forum
    object.author = author
  end

  def author_role_can_post
    postable_roles = forum.postable_roles
    return if postable_roles.empty?
    errors.add :base, :no_permissions if roles.empty?
  end

  def author_membership
    forum_memberships.available.find_by(forum: forum)
  end

  def roles
    Role::PERMISSIONS & postable_roles & author.roles.where(resource: forum).map(&:name)
  end
end
