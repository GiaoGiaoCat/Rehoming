require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/reporters'
require 'support/custom_header_setup'
require 'simplecov'
SimpleCov.start do
  add_filter '/vendor/' # Ignores any file containing "/vendor/" in its path.
  # add_filter "/lib/myfile.rb" # Ignores a specific file.
end
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
