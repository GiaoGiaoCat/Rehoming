module EncryptedId
  extend ActiveSupport::Concern

  CIPHER_NAME = 'aes-256-cbc'.freeze
  CIPHER_IV = ['1e5673b2572af26a8364a50af84c7d2a'].pack('H*')

  included do
  end

  module ClassMethods
    def encrypted_id(options = {})
      cattr_accessor :encrypted_id_key
      self.encrypted_id_key = Digest::SHA256.digest(options[:key] || encrypted_id_default_key)
      define_singleton_method(:find_single, -> { logger.info 'foo' })
    end

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

    def find_with_encrypted_id(*args)
      find(*args)
    end

    def encrypted_id_default_key
      name
    end

    def process_scope(scope)
      if scope.is_a? Array
        scope.map! { |encrypted_id| decrypt(encrypted_id_key, encrypted_id) }
      else
        decrypt(encrypted_id_key, scope.to_s)
      end
    end

    def decrypt(key, id)
      c = OpenSSL::Cipher.new(CIPHER_NAME).decrypt
      c.iv = CIPHER_IV
      c.key = key
      (c.update([id].pack('H*')) + c.final).to_i
    end

    def encrypt(key, id)
      c = OpenSSL::Cipher.new(CIPHER_NAME).encrypt
      c.iv = CIPHER_IV
      c.key = key
      (c.update(id.to_s) + c.final).unpack('H*')[0]
    end
  end

  def to_param
    self.class.encrypt(self.class.encrypted_id_key, id)
  end
end
