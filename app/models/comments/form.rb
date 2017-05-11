class Comments::Form < ActiveType::Record[Comment]
  attribute :post_id
  attribute :comment_id

  validates :content, presence: true
  validate :commentable_existence
  before_save :populate_commentable

  private

  def populate_commentable
    self.commentable = post || comment
  end

  def commentable_existence
    errors.add :commentable, :blank if post.blank? && comment.blank?
  end

  def post
    @post ||= post_id ? Post.find_by(id: post_id) : nil
  end

  def comment
    @comment ||= comment_id ? Comment.find_by(id: comment_id) : nil
  end
end
