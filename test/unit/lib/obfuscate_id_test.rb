require 'test_helper'

class ObfuscateIdTest < ActiveSupport::TestCase
  setup do
    class User < ApplicationRecord
      obfuscate_id
    end
  end

  test '应该可以正常来回转换 ' do
    assert_equal '31524066', User.first.obfuscated_id
    assert_equal 1, User.deobfuscate_id('31524066').to_i
  end
end
