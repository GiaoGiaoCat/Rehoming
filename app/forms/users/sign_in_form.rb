class Users::SignInForm < ApplicationForm
  attribute :code, :string
  attribute :userinfo

  validates :code, presence: true
  validates :userinfo, presence: true

  %i(user auth_token).each { |attr| delegate attr.to_sym, "#{attr}=".to_sym, to: :object }

  before_validation :ensure_userinfo_has_a_value
  before_validation :ensure_user_has_a_value

  def object_class
    Users::Session
  end

  private

  def setup_object_attributes
    self.userinfo = @authentication.userinfo
    self.user = @registration.user
  end

  def ensure_userinfo_has_a_value
    @authentication = Users::AuthenticationService.new(code: code)
    errors.add :base, :code_error unless @authentication.save
  end

  def ensure_user_has_a_value
    @registration = Users::RegistrationService.new(info: userinfo)
    errors.add :base, :userinfo_error unless @registration.save
  end
end
