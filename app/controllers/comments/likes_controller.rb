class Comments::LikesController < ApplicationController
  include ActsAsAction
  define_action_names verb: :like,
                      unverb: :dislike,
                      blk: proc { |liker, likeable|
                        Likes::Form.create(liker: liker, likeable: likeable)
                      }
end
