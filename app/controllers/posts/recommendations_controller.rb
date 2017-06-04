class Posts::RecommendationsController < ApplicationController
  include ActsAsAction
  define_action_names verb: :recommend, unverb: :unrecommend, authorize_name: :manage_recommend?
end
