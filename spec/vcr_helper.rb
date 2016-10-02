require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<MINUTE DOCK API KEY>') { MinuteDockProxy.api_key }
  config.filter_sensitive_data('<MINUTE DOCK USER ID>') { MinuteDockProxy.user_id }
  config.debug_logger = File.open('spec/vcr_errors.log', 'w')
end
