class User::SignIn < ActiveType::Object
  mattr_writer :wechat_client do
    EasyWechat::Client.new(ENV['wechat_app_id'], ENV['wechat_app_secret'])
  end

  attribute :code, :string
  attribute :auth_token, :string
  attribute :access_token
  attribute :userinfo
  attribute :user

  validates :code, presence: true
  validate :validate_access_token_exists
  validate :validate_userinfo_exists
  validate :validate_user_exists

  before_validation :ensure_access_token_has_a_value
  before_validation :ensure_userinfo_has_a_value
  before_validation :ensure_user_has_a_value
  # after_create :generate_auth_token

  def update_tracked_fields!(request)
    # delegator to user
  end

  private

  def ensure_access_token_has_a_value
    self.access_token = @@wechat_client.get_access_token(code)
  end

  def ensure_userinfo_has_a_value
    return if access_token.errcode
    self.userinfo = @@wechat_client.get_userinfo(access_token.access_token, access_token.openid)
  end

  def ensure_user_has_a_value
    return unless userinfo
    self.user = User::Generator.find_or_create_user_by(raw_info: userinfo)
  end

  def validate_access_token_exists
    errors.add(:access_token, access_token.errmsg) if access_token && access_token.errcode
  end

  def validate_userinfo_exists
    errors.add(:userinfo, userinfo.errmsg) if userinfo && userinfo.errcode
  end

  def validate_user_exists
    # I18n::InvalidLocale: :"zh-CN" is not a valid locale
    # errors.add(:user, :user_not_found, status: :not_found) unless user
    errors.add(:user, 'user not found') unless user
  end

  def set_auth_token_expired_time
    30.days.from_now.to_i
  end
end
