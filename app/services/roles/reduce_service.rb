class Roles::ReduceService < ApplicationService
  attribute :forum
  attribute :user
  attribute :role

  validates :forum, presence: true
  validates :user, presence: true
  validates :role, inclusion: { in: Role::PERMISSIONS }

  before_validation :format_role
  after_save :remove_role

  private

  def format_role
    self.role = role.to_s
  end

  def remove_role
    user.remove_role role, forum
  end
end
