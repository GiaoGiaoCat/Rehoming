class Feeds::PostJob < ApplicationJob
  queue_as :default

  def perform(member_ids, post_id)
    User.where(id: member_ids).find_each do |user|
      user.feeds
          .create!(
            sourceable_id:    post_id,
            sourceable_type:  'Post',
            event:            'new_post'
          )
    end
  end
end
