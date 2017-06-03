class ActiveRecord::Associations::CollectionProxy
  # NOTE: forum.posts.find('a0d3792d0dab6c6dea7b9de208dc3ea3') will called this method.
  #       just copy form `encrypted_id.rb`.
  def find(*args)
    scope = args.slice!(0)
    options = args.slice!(0) || {}
    if !options[:no_encrypted_id] && scope.to_s !~ /\A\d+\z/
      begin
        scope = process_scope(scope)
      rescue OpenSSL::Cipher::CipherError
        raise ActiveRecord::RecordNotFound.new("Could not decrypt ID #{scope}")
      end
    end
    super(scope)
  end
end
