require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<MINUTE DOCK API KEY>') { MinuteDock::Proxy.api_key }
  config.filter_sensitive_data('<MINUTE DOCK USER ID>') { MinuteDock::Proxy.user_id }
  config.debug_logger = File.open('spec/vcr_errors.log', 'w')
  config.ignore_hosts 'api.codacy.com'
end
