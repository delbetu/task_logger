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
      stub_const(
        'MinuteDock::Config::MINUTEDOCK_CREDENTIALS',
        'spec/fixtures/files/minutedock_credentials.yml'
      )

      result = MinuteDock::Config.load_minutedock_credentials
      expect(result['api_key']).not_to be_nil
      expect(result['user_id']).not_to be_nil
    end
  end

  describe '#store_credentials' do
    it 'stores credentials into config file' do
      system('rm -f spec/tmp/md_credentials.yml')
      stub_const('MinuteDock::Config::MINUTEDOCK_CREDENTIALS', 'spec/tmp/md_credentials.yml')
      credentials = { 'api_key' => 'valid', 'user_id' => 1111 }

      MinuteDock::Config.store_credentials(credentials)

      expect(MinuteDock::Config.load_minutedock_credentials).to eq(credentials)
    end
  end
end
