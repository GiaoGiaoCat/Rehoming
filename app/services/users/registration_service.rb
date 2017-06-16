class Users::RegistrationService < ApplicationService
  attribute :info
  attribute :user

  validates :info, presence: true

  after_save :ensure_user_has_a_value

  private

  def ensure_user_has_a_value
    user = User.find_or_initialize_by(unionid: info.unionid)
    user.update(nickname: info.nickname, headimgurl: info.headimgurl, raw_info: info.to_h) if user.new_record?
    self.user = user
  end
end
