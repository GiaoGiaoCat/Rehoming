class Posts::UnpinsController < ApplicationController
  include PinableResources
  pinable_resources action: :unpin
end
