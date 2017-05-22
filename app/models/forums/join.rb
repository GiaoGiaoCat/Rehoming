class Forums::Join < ActiveType::Object
  attribute :user_id
  attribute :forum_id

  belongs_to :user

  validates :forum_id, presence: true

  after_save :persist!

  def forum
    Forum.find(forum_id)
  end

  private

  def persist!
    return if user.blank? || user.forums.include?(forum)
    user.forums.append forum
  end
end
