class Feeds::PostJob < ApplicationJob
  queue_as :default

  def perform(member_ids, post_id)
    post = Post.find(post_id)
    ids = member_ids.delete_if { |member_id| member_id == post.user_id }
    User.where(id: ids).find_each do |user|
      user.feeds.create!(sourceable: post, event: 'new_post')
    end
  end
end
