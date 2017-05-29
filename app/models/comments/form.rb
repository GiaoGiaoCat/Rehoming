class Comments::Form < ActiveType::Record[Comment]
  after_create :feed_author

  private

  def feed_author
    commentable.author.feeds.create(
      sourceable: self,
      event:      'new_comment_of_post'
    )
  end
end
