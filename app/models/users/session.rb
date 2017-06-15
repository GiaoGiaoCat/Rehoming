class Users::Session < ActiveType::Object
  attribute :auth_token, :string
  attribute :user

  validates :user, presence: true
  validates :auth_token, presence: true

  before_validation :set_auth_token

  delegate :id, :to_param, to: :user, allow_nil: true

  private

  def set_auth_token
    self.auth_token = JsonWebToken.encode(payload)
  end

  def payload
    { user_id: user.to_param }
  end
end
