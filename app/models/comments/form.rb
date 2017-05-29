class Comments::Form < ActiveType::Record[Comment]
  after_create :feed

  private

  def feed
    if replied_user_id.blank?
      commentable.author.feeds.create(
        sourceable: self,
        event:      'new_comment_of_post'
      )
    else
      replied_user.feeds.create(
        sourceable: self,
        event:      'new_comment_of_comment'
      )

      commentable.author.feeds.create(
        sourceable: self,
        event:      'new_comment_of_post'
      ) if replied_user_id != commentable.author.id
    end
  end
end
