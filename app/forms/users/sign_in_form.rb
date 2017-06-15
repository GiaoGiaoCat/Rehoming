class Users::SignInForm < ApplicationForm
  attribute :code, :string

  validates :code, presence: true

  def object_class
    Users::Session
  end
end
