class Forums::Join < ActiveType::Object
  attribute :user_id
  attribute :forum_id

  belongs_to :user
  belongs_to :forum

  validate :join_status

  after_save :persist!

  private

  def join_status
    return if user.blank?
    errors.add :base, :cannot_join_twice if user.forums.include?(forum)
  end

  def persist!
    user.forums.append forum
  end
end
