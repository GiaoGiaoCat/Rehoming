class FeedSerializer < ApplicationSerializer
  cache key: 'feed'

  attributes :event, :read

  belongs_to :sourceable
end
