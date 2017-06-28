require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/autorun'

# Code coverage
require 'simplecov'
SimpleCov.start do
  add_filter '/vendor/' # Ignores any file containing "/vendor/" in its path.
end

# Improved Minitest output (color and progress bar)
require 'minitest/reporters'
Minitest::Reporters.use!

require 'fakeredis/minitest'
# Requires supporting ruby files with custom matchers and macros in support/ and its subdirectories.

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

  private

  def setup_role(role, forum)
    current_user.add_role role, forum
    yield
    current_user.remove_role role, forum
    assert_empty current_user.roles
  end
end
