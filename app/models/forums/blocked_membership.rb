class Forums::BlockedMembership < ActiveType::Object
  belongs_to :user
  belongs_to :forum

  attribute :user_id, :string
  attribute :forum_id, :integer

  validates :user_id, presence: true, numericality: { only_integer: true }, if: -> { user.blank? }
  validates :forum_id, presence: true

  before_validation :decrypt_user_id, if: -> { user.blank? }
  after_save :block_membership

  private

  def decrypt_user_id
    self.user_id = User.decrypt(User.encrypted_id_key, user_id)
  end

  def block_membership
    membership = forum.forum_memberships.find_by(user: user)
    membership&.block!
  end
end
