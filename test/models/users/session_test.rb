require 'test_helper'

class Users::SessionTest < ActiveSupport::TestCase
  test 'session create' do
    session = Users::Session.new(user: users(:victor))
    assert session.save
    assert_equal users(:victor).id, session.id
  end
end
