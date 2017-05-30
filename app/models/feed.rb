class Feed < ApplicationRecord
  belongs_to :sourceable, polymorphic: true
  belongs_to :targetable, polymorphic: true

  enum event: {
    new_post:               10,
    new_comment_of_post:    20,
    new_comment_of_comment: 30,
    new_reply_of_comment:   40,
    new_like_of_post:       50,
    new_like_of_comment:    60
  }
end
