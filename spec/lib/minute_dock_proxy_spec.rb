require 'spec_helper'
require 'vcr_helper'

describe MinuteDockProxy do

  describe '#report_entry' do
    let(:entry) do
      Entry.new({
        duration: 1600,
        description: 'test entry'
      })
    end

    it 'sends data to minutedock' do
      VCR.use_cassette('minute-dock-report-entry') do
        response = MinuteDockProxy.report_entry(entry)
      end
    end

    it 'raises error when using invalid credentials'

    it 'raises error when minutedock response status is not 200' do
      allow(MinuteDockProxy).to receive(:post).and_return(double(headers: { 'status' => 404 }))

      expect {
        MinuteDockProxy.report_entry(entry)
      }.to raise_error MinuteDockProxy::CommunicationError
    end
  end
end
