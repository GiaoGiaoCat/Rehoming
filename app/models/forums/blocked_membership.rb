class Forums::BlockedMembership < ActiveType::Object
  belongs_to :user
  belongs_to :forum

  attribute :user_id, :integer
  attribute :forum_id, :integer

  validates :user_id, presence: true
  validates :forum_id, presence: true

  after_save :block_membership

  private

  def block_membership
    membership = forum.forum_memberships.find_by(user: user)
    membership&.block!
  end
end
