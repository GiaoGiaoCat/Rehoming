module EasyWechat
  class Client
    attr_reader :appid, :secret

    def initialize(appid, secret)
      @appid = appid
      @secret = secret
    end

    def get_access_token(code)
      uri = URI(Figaro.env.wechat_open_host + 'sns/oauth2/access_token')
      params = { appid: @appid, secret: @secret, code: code, grant_type: 'authorization_code' }
      http_get(uri, params)
    end

    def get_userinfo(access_token, openid)
      uri = URI(Figaro.env.wechat_open_host + 'sns/userinfo')
      params = { access_token: access_token, openid: openid }
      http_get(uri, params)
    end

    private

    def http_get(uri, params)
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(uri)
      OpenStruct.new JSON.parse(response.body, symbolize_names: true) if response.is_a?(Net::HTTPSuccess)
    end
  end
end
