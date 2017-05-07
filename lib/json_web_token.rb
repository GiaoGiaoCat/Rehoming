# An Introduction to Using JWT Authentication in Rails
# http://www.sitepoint.com/introduction-to-using-jwt-in-rails/
class JsonWebToken
  # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode(payload, secret_key)
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    return HashWithIndifferentAccess.new(JWT.decode(token, secret_key, true, iss: iss, verify_iss: true)[0])
  rescue JWT::ExpiredSignature, JWT::InvalidIssuerError, JWT::VerificationError
    # Handle expired token, e.g. logout user or deny access
    raise JWT::DecodeError.new("Cannot decode the token #{token}")
  end

  # Default options to be encoded in the token
  def self.meta
    { exp: 30.days.from_now.to_i, iss: iss }
  end

  # Validates if the token is expired by exp parameter
  def self.expired(payload)
    Time.current(payload['exp']) < Time.current
  end

  def self.secret_key
    ENV['jwt_secret']
  end

  def self.iss
    'Rehoming API V1.0'
  end

  class << self
    alias issue encode
  end
end
