require 'spec_helper'
require 'vcr_helper'

describe MinuteDock::Proxy do

  describe '#report_entry' do
    let(:entry) do
      Entry.new({
        duration: 1600,
        description: 'test entry'
      })
    end

    it 'sends data to minutedock' do
      VCR.use_cassette('minute-dock-report-entry') do
        response = MinuteDock::Proxy.report_entry(entry)
      end
    end

    it 'raises error when using invalid credentials'

    it 'raises error when minutedock response status is not 200' do
      allow(MinuteDock::Proxy).to receive(:post).and_return(double(headers: { 'status' => 404 }))

      expect {
        MinuteDock::Proxy.report_entry(entry)
      }.to raise_error MinuteDock::CommunicationError
    end
  end

  describe '#fetch_projects' do
    it 'returns projects for the current account' do
      VCR.use_cassette('minute-dock-fetch-projects') do
        response = MinuteDock::Proxy.fetch_projects
        expect(response.values).not_to be_empty
      end
    end

    it 'raises error when using invalid credentials'
  end

  describe '#fetch_categories' do
    it 'returns categories for the current account' do
      VCR.use_cassette('minute-dock-fetch-categories') do
        response = MinuteDock::Proxy.fetch_categories
        expect(response.values).not_to be_empty
      end
    end
  end

  describe '#valid_credentials?' do
    it 'returns false when credentials are invalid' do
      VCR.use_cassette('minute-dock-invalid-credentials') do
        allow(MinuteDock::Proxy).to receive(:api_key).and_return('invalid')
        result = MinuteDock::Proxy.valid_credentials?
        expect(result).to be_falsy
      end
    end

    it 'returns true when credentials are valid' do
      VCR.use_cassette('minute-dock-valid-credentials') do
        result = MinuteDock::Proxy.valid_credentials?
        expect(result).to be_truthy
      end
    end
  end

  describe '#fetch_user_id' do
    it 'returns the user_id when receiveing a valid api_key' do
      VCR.use_cassette('minute-dock-fetch-user-id') do
        valid_api_key = MinuteDock::Proxy.api_key
        valid_user_id = MinuteDock::Proxy.user_id
        result = MinuteDock::Proxy.fetch_user_id(valid_api_key)
        expect(result).to eq(valid_user_id)
      end
    end
  end
end
