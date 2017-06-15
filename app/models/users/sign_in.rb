class Users::SignIn < ActiveType::Object
  mattr_writer :wechat_client do
    EasyWechat::Client.new(ENV['wechat_app_id'], ENV['wechat_app_secret'])
  end

  belongs_to :user

  attribute :code, :string
  attribute :auth_token, :string
  attribute :user_id, :integer
  attribute :access_token
  attribute :userinfo

  validates :code, presence: true
  validates :user, presence: true
  validates :auth_token, presence: true
  validate :validate_access_token_exists
  validate :validate_userinfo_exists

  before_validation :ensure_access_token_has_a_value
  before_validation :ensure_userinfo_has_a_value
  before_validation :ensure_user_id_has_a_value
  before_validation :ensure_auth_token_has_a_value

  delegate :id, to: :user, allow_nil: true

  private

  def ensure_access_token_has_a_value
    self.access_token = @@wechat_client.get_access_token(code)
  end

  def ensure_userinfo_has_a_value
    return if access_token.errcode
    self.userinfo = @@wechat_client.get_userinfo(access_token.access_token, access_token.openid)
  end

  def ensure_user_id_has_a_value
    return unless userinfo
    return unless registration
    self.user_id = registration.user.id
  end

  def ensure_auth_token_has_a_value
    return unless user
    payload = { user_id: user.to_param }
    self.auth_token = JsonWebToken.encode(payload)
  end

  def validate_access_token_exists
    errors.add(:access_token, access_token.errmsg) if access_token && access_token.errcode
  end

  def validate_userinfo_exists
    errors.add(:userinfo, userinfo.errmsg) if userinfo && userinfo.errcode
  end

  def registration
    registration = Users::RegistrationService.new(info: userinfo)
    return unless registration.save
    registration
  end
end
