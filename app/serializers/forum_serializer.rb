class ForumSerializer < ApplicationSerializer
  attributes :name, :description, :cover, :background_color

  has_one :preference
end
