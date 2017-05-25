class Forums::MembershipRequestSerializer < ApplicationSerializer
  type 'membership_requests'

  attribute :state
  belongs_to :user
  belongs_to :forum
end
