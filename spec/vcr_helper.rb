require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<MINUTE DOCK API KEY>') { ENV.fetch('MINUTE_DOCK_API_KEY') }
  config.filter_sensitive_data('<MINUTE DOCK USER ID>') { ENV.fetch('MINUTE_DOCK_USER_ID') }
  config.debug_logger = File.open('spec/vcr_errors.log', 'w')
end
