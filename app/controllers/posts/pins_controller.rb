class Posts::PinsController < ApplicationController
  include PinableResources
  pinable_resources action: :pin
end
