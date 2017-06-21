class AttachmentSerializer < ApplicationSerializer
  cache key: 'attachment'
  attributes :category, :url
end
