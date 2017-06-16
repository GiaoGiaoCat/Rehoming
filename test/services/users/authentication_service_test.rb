require 'test_helper'

class Users::AuthenticationServiceTest < ActiveSupport::TestCase
  def setup
    @mock = MiniTest::Mock.new
    access_token = OpenStruct.new(JSON.parse(file_fixture('wechat_oauth_access_token.json').read))
    userinfo = OpenStruct.new(JSON.parse(file_fixture('wechat_oauth_userinfo.json').read))
    @mock.expect(:get_access_token, access_token, [String])
    @mock.expect(:get_userinfo, userinfo, [String, String])
  end

  test '验证网络正常时，根据 code 从 wechat 获取 info' do
    Users::AuthenticationService.class_variable_set(:@@wechat_client, @mock)
    authentication = Users::AuthenticationService.new(code: '071Vd3MI1pwaX70ATgNI1c8YLI1Vd3Mj')
    authentication.save
    assert authentication.access_token
    assert authentication.userinfo
    @mock.verify
  end
end
