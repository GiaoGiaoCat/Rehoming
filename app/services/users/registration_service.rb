class Users::RegistrationService < ApplicationService
  attribute :info

  validates :info, presence: true

  private

  def setup_object_attributes
    user = User.find_or_initialize_by(unionid: info.unionid)
    user.update(nickname: info.nickname, headimgurl: info.headimgurl, raw_info: info.to_h) if user.new_record?
    self.object = user
  end
end
