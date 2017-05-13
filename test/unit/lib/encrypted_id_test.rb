require 'test_helper'

class EncryptedIdTest < ActiveSupport::TestCase
  ModelA = Struct.new(:id) do
    include EncryptedId
    encrypted_id key: 'BsdetCsG3fVJRmgwngnk'
  end

  ModelB = Struct.new(:id) do
    include EncryptedId
    encrypted_id key: 'MJqwWKzdGgj8ZkpEhVhE'
  end

  def setup
    @instant_a = ModelA.new(1)
    @instant_b = ModelB.new(1)
  end

  test '验证对象可以返回 encrypted_id' do
    assert_equal '30e1c105b857c313d8851a21b89a770d', @instant_a.to_param
    assert_equal '5ea7170e68ea97146d7cb63ba405ad9a', @instant_b.to_param
  end

  test '验证加载模块的类可以加密 id' do
    assert_equal '30e1c105b857c313d8851a21b89a770d', ModelA.encrypt(ModelA.encrypted_id_key, @instant_a.id)
    assert_equal '5ea7170e68ea97146d7cb63ba405ad9a', ModelB.encrypt(ModelB.encrypted_id_key, @instant_b.id)
  end

  test '验证加载模块的类可以解密 encrypted_id' do
    assert_equal 1, ModelA.decrypt(ModelA.encrypted_id_key, @instant_a.to_param)
    assert_equal 1, ModelA.decrypt(ModelB.encrypted_id_key, @instant_b.to_param)
  end

  test '验证加载模块的类解密 encrypted_id 所对应的 key 必须正确' do
    assert_raises OpenSSL::Cipher::CipherError do
      ModelA.decrypt(ModelB.encrypted_id_key, @instant_a.to_param)
    end
  end
end
