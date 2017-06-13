class Forums::CreateForm < ApplicationForm
  attribute :moderator

  validates :moderator, presence: true

  Forum.column_names.each { |attr| delegate attr.to_sym, "#{attr}=".to_sym, to: :object }

  after_save :ensure_moderator

  private

  def ensure_moderator
    moderator.join_forum object
    moderator.add_role :moderator, object
  end
end
