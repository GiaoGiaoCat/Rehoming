class Users::AuthenticationService < ApplicationService
  mattr_writer :wechat_client do
    EasyWechat::Client.new(ENV['wechat_app_id'], ENV['wechat_app_secret'])
  end

  attribute :code, :string
  attribute :access_token
  attribute :userinfo

  validates :code, presence: true
  validate :validate_access_token_exists
  validate :validate_userinfo_exists

  before_validation :ensure_access_token_has_a_value
  before_validation :ensure_userinfo_has_a_value

  private

  def perform; end

  def validate_access_token_exists
    errors.add(:access_token, access_token.errmsg) if access_token && access_token.errcode
  end

  def validate_userinfo_exists
    errors.add(:userinfo, userinfo.errmsg) if userinfo && userinfo.errcode
  end

  def ensure_access_token_has_a_value
    self.access_token = @@wechat_client.get_access_token(code)
  end

  def ensure_userinfo_has_a_value
    return if access_token.errcode
    self.userinfo = @@wechat_client.get_userinfo(access_token.access_token, access_token.openid)
  end
end
