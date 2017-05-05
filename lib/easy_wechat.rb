require 'net/https'
require 'uri'
require 'json'
require 'easy_wechat/client'

# how to:
# client = EasyWechat::Client.new("APPID", "APPSECRET")
# access_token = client.get_access_token('code')
# userinfo = client.get_userinfo('access_token', 'openid')
# readmore: https://github.com/AmazingPlus/Rehoming/wiki/EasyWechat
