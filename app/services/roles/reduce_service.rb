class Roles::ReduceService < ActiveType::Object
  attribute :forum_id, :integer
  attribute :user_id, :integer
  attribute :role

  belongs_to :user
  belongs_to :forum

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
