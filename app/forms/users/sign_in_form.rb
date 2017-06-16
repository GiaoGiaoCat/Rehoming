class Users::SignInForm < ApplicationForm
  attribute :code, :string

  validates :code, presence: true

  %i(user auth_token).each { |attr| delegate attr.to_sym, "#{attr}=".to_sym, to: :object }

  before_validation :wechat_authentication
  before_validation :initialize_user_by_userinfo

  def object_class
    Users::Session
  end

  private

  def setup_object_attributes
    self.user = @registration.user
  end

  def wechat_authentication
    @authentication = Users::AuthenticationService.new(code: code)
    errors.add :base, :code_error unless @authentication.save
  end

  def initialize_user_by_userinfo
    @registration = Users::RegistrationService.new(info: @authentication.userinfo)
    errors.add :base, :userinfo_error unless @registration.save
  end
end
