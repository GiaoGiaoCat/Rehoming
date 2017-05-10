require 'test_helper'

class Users::SignInTest < ActiveSupport::TestCase
  def setup
    @mock = MiniTest::Mock.new
    access_token = OpenStruct.new(JSON.parse(file_fixture('wechat_oauth_access_token.json').read))
    userinfo = OpenStruct.new(JSON.parse(file_fixture('wechat_oauth_userinfo.json').read))
    @mock.expect(:get_access_token, access_token, [String])
    @mock.expect(:get_userinfo, userinfo, [String, String])
  end

  test '验证网络正常时，微信登录可以获取 auth token' do
    Users::SignIn.class_variable_set(:@@wechat_client, @mock)
    sign_in = Users::SignIn.new(code: '071Vd3MI1pwaX70ATgNI1c8YLI1Vd3Mj')
    sign_in.save
    assert_equal sign_in.user, users(:victor)
    assert sign_in.auth_token
    @mock.verify
  end
end
