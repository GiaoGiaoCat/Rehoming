class Forums::Members::AsAdmin < ActiveType::Object
  attribute :forum
  attribute :user

  validates :forum, presence: true
  validates :user, presence: true
  validate :need_membership

  after_save :persist

  def destroy
    return if invalid?
    user.remove_role :admin, forum.becomes(Forum)
  end

  private

  def need_membership
    return if forum.members.include?(user)
    errors.add :base, :need_membership
  end

  def persist
    user.add_role :admin, forum.becomes(Forum)
  end
end
