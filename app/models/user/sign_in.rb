class User::SignIn < ActiveType::Object
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
  validate :validate_access_token_exists
  validate :validate_userinfo_exists
  validate :validate_user_exists

  before_validation :ensure_access_token_has_a_value
  before_validation :ensure_userinfo_has_a_value
  before_validation :ensure_user_id_has_a_value
  # after_create :generate_auth_token

  delegate :update_tracked_fields!, to: :user

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
    user = User::Generator.find_or_create_user_by(raw_info: userinfo)
    self.user_id = user.id
  end

  def validate_access_token_exists
    errors.add(:access_token, access_token.errmsg) if access_token && access_token.errcode
  end

  def validate_userinfo_exists
    errors.add(:userinfo, userinfo.errmsg) if userinfo && userinfo.errcode
  end

  def validate_user_exists
    # I18n::InvalidLocale: :"zh-CN" is not a valid locale
    # errors.add(:user_id, :user_not_found, status: :not_found) unless user_id
    errors.add(:user_id, 'user not found') unless user_id
  end
end
