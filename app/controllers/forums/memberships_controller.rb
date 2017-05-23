class Forums::MembershipsController < ApplicationController
  include ActsAsAction
  define_action_names verb: :join_forum, unverb: :quit_forum
end
