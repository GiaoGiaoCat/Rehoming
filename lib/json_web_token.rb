# An Introduction to Using JWT Authentication in Rails
# http://www.sitepoint.com/introduction-to-using-jwt-in-rails/
class JsonWebToken
  def self.encode(payload)
    secret_key = ENV['jwt_secret']
    JWT.encode(payload, secret_key)
  end

  def self.decode(token)
    secret_key = ENV['jwt_secret']
    return HashWithIndifferentAccess.new(JWT.decode(token, secret_key)[0])
  rescue
    nil
  end
end
