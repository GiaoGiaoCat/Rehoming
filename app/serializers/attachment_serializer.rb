class AttachmentSerializer < ApplicationSerializer
  cache key: 'attachments'
  attributes :category, :url
end
