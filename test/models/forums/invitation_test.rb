require 'test_helper'

class Forums::InvitationTest < ActiveSupport::TestCase
  test 'ensure token' do
    times = 100
    assert_difference 'Forums::Invitation.count', times do
      times.times do
        invitation = Forums::Invitation.new(forum: forums(:one))
        assert invitation.save
        assert invitation.token.present?
      end
    end
  end
end
