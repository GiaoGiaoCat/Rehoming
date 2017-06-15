require 'test_helper'

class Users::RegistrationServiceTest < ActiveSupport::TestCase
  test '根据 info 注册用户' do
    userinfo = OpenStruct.new(JSON.parse(file_fixture('wechat_oauth_userinfo.json').read))
    registration = Users::RegistrationService.new(object: User.new, info: userinfo)
    assert registration.save
    assert registration.object
  end
end
