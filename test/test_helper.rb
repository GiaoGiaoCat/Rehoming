require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in support/ and its subdirectories.
require 'support/custom_header_setup'

# Code coverage
require 'simplecov'
SimpleCov.start do
  add_filter '/vendor/' # Ignores any file containing "/vendor/" in its path.
end

# Improved Minitest output (color and progress bar)
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  set_fixture_class 'user/forum_preferences' => Users::ForumPreference
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def setup
    @headers = { 'HTTP_AUTHORIZATION' => JsonWebToken.issue(user_id: users(:victor).id) }
  end

  def current_user
    @current_user ||= users(:victor)
  end
end
