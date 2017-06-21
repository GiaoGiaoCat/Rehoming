class LikeSerializer < ApplicationSerializer
  cache key: 'like'

  belongs_to :liker
end
