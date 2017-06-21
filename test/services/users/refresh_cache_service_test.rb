require 'test_helper'

class Users::RefreshCacheServiceTest < ActiveSupport::TestCase
  setup do
    @victor = users(:victor)
  end

  test '更新用户信息会刷新缓存' do
    assert_changes -> { Rails.cache.read(@victor.to_param) } do
      params = { name: 'updated.user', sourceable: @victor, handler: @victor }
      Users::RefreshCacheService.create(params)
    end
  end
end
