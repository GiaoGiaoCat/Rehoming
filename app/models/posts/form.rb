class Posts::Form < ActiveType::Record[Post]

  after_create :feed_forum_members

  private

  def feed_forum_members
    Feeds::PostJob.perform_later(forum.members.ids, id)
  end
end
