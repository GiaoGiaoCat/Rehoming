class Forums::MembershipRequestSerializer < ApplicationSerializer
  type 'membership_requests'

  attribute :status
  belongs_to :user
  belongs_to :forum
end
