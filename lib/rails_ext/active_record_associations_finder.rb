class ActiveRecord::Associations::CollectionProxy
  # NOTE: forum.posts.find('a0d3792d0dab6c6dea7b9de208dc3ea3') will called this method.
  #       just copy form `encrypted_id.rb`.
  prepend RailsExt::ActiveRecordFinder
end
