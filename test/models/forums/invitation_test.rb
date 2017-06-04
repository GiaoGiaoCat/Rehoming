require 'test_helper'

class Forums::InvitationTest < ActiveSupport::TestCase
  test 'ensure token' do
    invitation = Forums::Invitation.new(forum: forums(:one))
    assert invitation.save
    assert invitation.token.present?
  end
end
