class ApplicationForm < ActiveType::Object
  self.abstract_class = true

  attribute :object

  validates :object, presence: true
  validate :verify_object_class_correct
  validate :verify_object_valid

  before_validation :setup_object_attributes
  before_validation :setup_associations
  after_save :sync

  def initialize(params)
    self.object = object_class.new
    super
  end

  # NOTE: can implemented by subtypes.
  def object_class
    self.class.to_s[/\A([^:]+)/, 1].singularize.constantize
  rescue
    raise "Could not determine form class from #{self.class}."
  end

  private

  # NOTE: can implemented by subtypes.
  def sync
    object.save
  end

  def verify_object_class_correct
    errors.add :base, :object_class_incorrect unless object.is_a? object_class
  end

  def verify_object_valid
    promote_errors(object.errors) unless object.valid?
  end

  # NOTE: can implemented by subtypes.
  def setup_object_attributes; end

  # NOTE: can implemented by subtypes.
  def setup_associations; end

  def promote_errors(child_errors)
    child_errors.each { |attribute, message| errors.add(attribute, message) }
  end
end
