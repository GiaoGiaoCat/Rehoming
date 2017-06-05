class Forums::BlockedMember < ActiveType::Object
  attribute :user_id, :string
  attribute :forum_id, :integer

  belongs_to :user
  belongs_to :forum

  validates :user_id, presence: true, numericality: { only_integer: true }, if: -> { user.blank? }
  validates :forum_id, presence: true

  before_validation :decrypt_user_id, if: -> { user.blank? }
  after_save :block_member

  def destroy
    forum.memberships.find_by(user_id: decrypt_user_id).unblock!
  end

  private

  def decrypt_user_id
    self.user_id = decrypted_user_id
  end

  def decrypted_user_id
    User.decrypt(User.encrypted_id_key, user_id)
  end

  def block_member
    forum.memberships.find_by(user: user).try(:block!)
  end
end
