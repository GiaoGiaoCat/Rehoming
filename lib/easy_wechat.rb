require 'net/https'
require 'uri'
require 'json'
require 'easy_wechat/client'

# how to:
# client = EasyWechat::Client.new("APPID", "APPSECRET")
# access_token = client.get_access_token('code')
# userinfo = client.get_userinfo('access_token', 'openid')

# Exmaple:
# client = EasyWechat::Client.new(Figaro.env.wechat_app_id, Figaro.env.wechat_app_secret)
# access_token = client.get_access_token('041lfpvU1NoH0U0iWirU1mScvU1lfpv4')
# userinfo = client.get_userinfo('-mN-cLx9I-5Y-stQohL8P4xjYuCcae43VBqO1flsKbY9rq3C_gNrLyQ01RYXdTZXwq3D8rCEBiaoFWhp6HJf4RGLQJ53-i4gReYOa2s6nAM', 'oNlWVwv6jR5e-nPfQsm8l1EcNJVQ')
