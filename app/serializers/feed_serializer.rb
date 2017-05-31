class FeedSerializer < ApplicationSerializer
  attributes :event, :read

  belongs_to :sourceable
end
