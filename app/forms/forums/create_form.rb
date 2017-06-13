class Forums::CreateForm < ApplicationForm
  attribute :moderator

  validates :moderator, presence: true

  Forum.column_names.each { |attr| delegate attr.to_sym, "#{attr}=".to_sym, to: :form_object }

  private

  def sync
    form_object.save
    ensure_moderator
  end

  def ensure_moderator
    moderator.join_forum(form_object)
    moderator.add_role :moderator, form_object
  end
end
