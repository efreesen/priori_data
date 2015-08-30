require 'vcr'
require 'rspec'
require 'pry-meta'
require './lib/priori_data'

# Redefining all models
  Object.send(:remove_const, :Category)

  require './spec/mocks/category'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.order = :random

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect

    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end
end
