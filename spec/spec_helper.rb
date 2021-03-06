require_relative '../load_environment'
require 'byebug'
require 'codacy-coverage'
Codacy::Reporter.start

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.after(:all) do
    system('rm -f spec/tmp/*.yml')
  end
end
