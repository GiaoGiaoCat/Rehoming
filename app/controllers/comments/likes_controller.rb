class Comments::LikesController < ApplicationController
  include ActsAsAction
  define_action_names verb: :like, unverb: :dislike, instrument_name: 'liked.comment'
end
