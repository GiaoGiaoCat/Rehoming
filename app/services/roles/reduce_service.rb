class Roles::ReduceService < ApplicationService
  attribute :forum_id, :integer
  attribute :user_id, :integer
  attribute :role

  belongs_to :user
  belongs_to :forum

  validates :role, inclusion: { in: Role::PERMISSIONS }

  before_validation :format_role

  private

  def perform
    user.remove_role role, forum
  end

  def format_role
    self.role = role.to_s
  end
end
