class AttachmentSerializer < ApplicationSerializer
  type 'attachments'
  attributes :category, :url
end
