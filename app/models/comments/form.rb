class Comments::Form < ActiveType::Record[Comment]
  after_create :feed

  private

  def feed
    if replied_user_id.blank?
      feed_commentable_author
    else
      feed_replied_user
      feed_commentable_author if replied_user_id != commentable.author.id
    end
  end

  def feed_commentable_author
    commentable.author.feeds.create(
      sourceable: self,
      event:      'new_comment_of_post'
    )
  end

  def feed_replied_user
    replied_user.feeds.create(
      sourceable: self,
      event:      'new_comment_of_comment'
    )
  end
end
