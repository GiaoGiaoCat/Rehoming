class Forums::Rename < ActiveType::Object
  attribute :name
  attribute :user_id
  attribute :forum_id

  belongs_to :user
  belongs_to :forum

  validates :name, presence: true
  validates :user_id, presence: true
  validates :forum_id, presence: true
  validate :join_status

  after_save :persist!

  private

  def join_status
    return if user.blank?
    errors.add :base, :must_join_first if membership.blank?
  end

  def persist!
    membership = Forums::Membership.find_by(user_id: user_id, forum_id: forum_id)
    membership.update!(nickname: name)
  end

  def membership
    @membership ||= Forums::Membership.find_by(user_id: user_id, forum_id: forum_id)
  end
end
