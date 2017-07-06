class Comments::LikesController < ApplicationController
  include ActsAsActionStore
  define_action_names verb_name: :like, instrument_name: 'liked.comment'
end
