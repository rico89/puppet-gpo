RSpec.configure do |config|
  config.mock_with :rspec # use rspec-mocks
end
require 'puppetlabs_spec_helper/module_spec_helper'
require 'coveralls'
Coveralls.wear!
