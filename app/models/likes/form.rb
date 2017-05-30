class Likes::Form < ActiveType::Record[Like]
  after_create :feed

  private

  def feed
    author = likeable&.author
    return if author.blank?
    author.feeds.create(sourceable: self, event: 'new_like_of_comment')
  end
end
