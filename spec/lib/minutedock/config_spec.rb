require 'spec_helper'

describe MinuteDock::Config do
  describe '#load_minutedock_credentials' do
    it 'raise an error when config file does not exists' do
      stub_const('MinuteDock::Config::MINUTEDOCK_CREDENTIALS', 'no/exists.yml')

      expect {
        MinuteDock::Config.load_minutedock_credentials
      }.to raise_error MinuteDock::NoCredentialsError
    end

    it 'returns api_key and user_id credentials' do
      result = MinuteDock::Config.load_minutedock_credentials
      expect(result['api_key']).not_to be_nil
      expect(result['user_id']).not_to be_nil
    end
  end
end
