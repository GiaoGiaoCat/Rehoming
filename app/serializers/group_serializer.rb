class GroupSerializer < ApplicationSerializer
  type 'groups'
  attributes :title, :description, :cover, :background_color
end
