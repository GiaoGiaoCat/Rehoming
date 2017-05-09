class Groups::Join < ActiveType::Object
  attribute :user_id
  attribute :group_id

  belongs_to :user
  belongs_to :group

  validate :join_status

  after_save :persist!

  private

  def join_status
    return if user.blank?
    errors.add :base, :cannot_join_twice if user.groups.include?(group)
  end

  def persist!
    user.groups.append group
  end
end
