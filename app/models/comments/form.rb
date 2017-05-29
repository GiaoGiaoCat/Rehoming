class Comments::Form < ActiveType::Record[Comment]
  after_create :feed

  private

  def feed
    commentable.author.feeds.create(
      sourceable: self,
      event:      'new_comment_of_post'
    )

    return if replied_user_id.blank?
    replied_user.feeds.create(
      sourceable: self,
      event:      'new_comment_of_comment'
    )
  end
end
