class ApplicationSerializer < ActiveModel::Serializer
  delegate :to_param, to: :object

  alias id to_param

  def attributes(*)
    hash = super
    hash.each do |key, value|
      hash.delete(key) if value.nil?
    end
    hash
  end
end
