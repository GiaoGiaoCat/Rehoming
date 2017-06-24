class Forums::Invitation < ApplicationRecord
  belongs_to :forum
  belongs_to :user, optional: true

  validates :token, presence: true, uniqueness: true

  before_validation :ensure_token

  scope :available, -> { where(accepted_at: nil) }

  def used_by(user)
    update(user: user, accepted_at: Time.zone.now)
  end

  private

  def ensure_token
    self.token ||= loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
