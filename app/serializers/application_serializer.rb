class ApplicationSerializer < ActiveModel::Serializer
  def attributes(*)
    hash = super
    hash.each do |key, value|
      hash.delete(key) if value.nil?
    end
    hash
  end

  def id
    object.to_param
  end
end
