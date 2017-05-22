class Forums::Quit < ActiveType::Object
  attribute :user_id
  attribute :forum_id

  belongs_to :user
  belongs_to :forum

  validates :user_id, presence: true
  validates :forum_id, presence: true
  validate :join_status

  after_save :persist!

  private

  def join_status
    return if user.blank?
    errors.add :base, :must_join_first unless user.forums.include?(forum)
  end

  def persist!
    user.forums.delete forum
  end
end
