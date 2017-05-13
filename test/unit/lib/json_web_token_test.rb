require 'test_helper'

class JsonWebTokenTest < ActiveSupport::TestCase
  def setup
    @victor = users(:victor)
    @payload = { user_id: @victor.id }
  end

  test '验证可以签发 token 并解码' do
    token = JsonWebToken.issue(@payload)
    payload = JsonWebToken.decode(token)
    assert_equal @payload[:user_id], payload[:user_id]
  end

  test '验证被篡改的 token 解码会抛错' do
    token = JsonWebToken.issue(@payload)
    token += 'A'
    assert_raises JWT::DecodeError do
      JsonWebToken.decode(token)
    end
  end

  test '验证 token 过期后解码会抛错' do
    token = JsonWebToken.issue(@payload.merge(exp: (Time.current.to_i - 10)))
    assert_raises JWT::DecodeError do
      JsonWebToken.decode(token)
    end
  end
end
