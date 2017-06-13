class Comments::CreateForm < ApplicationForm
  attribute :commentable
  attribute :author
  attribute :replied_user_id, :string

  validate :user_should_in_forum
  validate :postable_until_tomorrow

  Comment.column_names.each { |attr| delegate attr.to_sym, "#{attr}=".to_sym, to: :object }
  delegate :attachments_attributes=, to: :object
  delegate :forum_memberships, to: :author
  delegate :forum, to: :commentable

  private

  def setup_associations
    object.commentable = commentable
    object.author = author
  end

  def user_should_in_forum
    errors.add :base, :not_in_forum unless author_membership
  end

  def postable_until_tomorrow
    return unless forum.postable_until_tomorrow?
    errors.add :base, :postable_until_tomorrow if author_membership.created_at.next_day > Time.current
  end

  def author_membership
    forum_memberships.available.find_by(forum: forum)
  end
end
