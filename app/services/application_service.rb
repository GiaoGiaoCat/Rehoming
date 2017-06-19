class ApplicationService < ActiveType::Object
  self.abstract_class = true

  after_save :perform

  private

  def perform
    raise NotImplementedError, 'Must be implemented by subtypes.'
  end
end
