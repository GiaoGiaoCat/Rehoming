class LikeSerializer < ApplicationSerializer
  cache key: 'likes'

  belongs_to :liker
end
