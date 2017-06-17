class Forums::MembershipRequestSerializer < ApplicationSerializer
  type 'membership_request'

  attribute :status
  belongs_to :user
  belongs_to :forum
end
