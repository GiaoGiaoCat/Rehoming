require 'test_helper'

class ObfuscateIdTest < ActiveSupport::TestCase
  setup do
    class User < ApplicationRecord
      obfuscate_id
    end
  end

  test '应该可以正常来回转换 ' do
    assert_equal '96926233', User.first.obfuscated_id
    assert_equal 1, User.deobfuscate_id('02196387').to_i
  end

  test '测试 100 个连续数字' do
    100.times do |i|
      u = User.first
      u.id = i + 1
      assert_nothing_raised do
        User.first.obfuscated_id
      end
    end
  end
end
