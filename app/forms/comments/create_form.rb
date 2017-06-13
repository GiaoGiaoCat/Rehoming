class Comments::CreateForm < ApplicationForm
  include ValidPostingRights

  attribute :commentable
  attribute :author
  attribute :replied_user_id, :string

  Comment.column_names.each { |attr| delegate attr.to_sym, "#{attr}=".to_sym, to: :object }
  delegate :attachments_attributes=, to: :object
  delegate :forum_memberships, to: :author
  delegate :forum, to: :commentable

  private

  def setup_associations
    object.commentable = commentable
    object.author = author
  end

  def author_membership
    forum_memberships.available.find_by(forum: forum)
  end
end
