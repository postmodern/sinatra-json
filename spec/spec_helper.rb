require 'test_helpers'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.expect_with :rspec#, :stdlib
  config.include Sinatra::TestHelpers
end
