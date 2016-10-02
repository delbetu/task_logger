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
end
