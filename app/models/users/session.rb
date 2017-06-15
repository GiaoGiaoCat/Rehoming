class Users::Session < ActiveType::Object
  attribute :auth_token, :string
  attribute :user

  validates :user, presence: true

  after_save :ensure_auth_token

  delegate :id, :to_param, to: :user, allow_nil: true

  private

  def ensure_auth_token_has_a_value
    self.auth_token = JsonWebToken.encode(payload)
  end

  def payload
    { user_id: user.to_param }
  end
end
