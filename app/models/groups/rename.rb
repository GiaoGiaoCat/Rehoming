class Groups::Rename < ActiveType::Object
  attribute :name
  attribute :user_id
  attribute :group_id

  belongs_to :user
  belongs_to :group

  validates :name, presence: true
  validates :user_id, presence: true
  validates :group_id, presence: true
  validate :join_status

  after_save :persist!

  private

  def join_status
    return if user.blank?
    errors.add :base, :must_join_first if enrollment.blank?
  end

  def persist!
    enrollment = Groups::Enrollment.find_by(user_id: user_id, group_id: group_id)
    enrollment.update!(nickname: name)
  end

  def enrollment
    @enrollment ||= Groups::Enrollment.find_by(user_id: user_id, group_id: group_id)
  end
end
