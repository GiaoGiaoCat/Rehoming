class Feed < ApplicationRecord
  belongs_to :sourceable, polymorphic: true
  belongs_to :targetable, polymorphic: true

  enum event: {
    new_post:               10,
    new_comment_of_post:    20,
    new_comment_of_comment: 30,
    like:                   40
  }
end
