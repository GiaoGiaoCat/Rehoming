class ApplicationForm < ActiveType::Object
  self.abstract_class = true

  attribute :form_object

  validates :form_object, presence: true
  validate :verify_form_object_class_correct
  validate :verify_form_object_valid

  after_save :sync

  # NOTE: can implemented by subtypes.
  def form_object_class
    self.class.to_s[/\A([^:]+)/, 1].singularize.constantize
  rescue
    raise "Could not determine form class from #{self.class}."
  end

  private

  def sync
    raise NotImplementedError, 'Must be implemented by subtypes.'
  end

  def verify_form_object_class_correct
    errors.add :base, :form_object_class_incorrect unless form_object.is_a? form_object_class
  end

  def verify_form_object_valid
    setup_associations
    promote_errors(form_object.errors) unless form_object.valid?
  end

  # NOTE: can implemented by subtypes.
  def setup_associations; end

  def promote_errors(child_errors)
    child_errors.each { |attribute, message| errors.add(attribute, message) }
  end
end
